//
//  SPSearchResultsView.swift
//  SouthPark
//
//  Created by Nazar on 13.07.2023.
//

import UIKit

protocol SPSearchResultsViewDelegate: AnyObject {
    func spSearchResultsView(_ resultsView: SPSearchResultsView, didTapLocationAt index: Int)
}

/// Shows search results UI
class SPSearchResultsView: UIView {
   
    weak var delegate: SPSearchResultsViewDelegate?
    
    private var viewModel: SPSearchResultsViewModel? {
            didSet {
                self.processViewModel()
            }
        }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(SPLocationTableViewCell.self, forCellReuseIdentifier: SPLocationTableViewCell.cellIdentifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 35 // Adjust the vertical spacing between cells
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SPCharacterCollectionViewCell.self, forCellWithReuseIdentifier: SPCharacterCollectionViewCell.cellIdentifier)
        
        collectionView.register(SPEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: SPEpisodeCollectionViewCell.cellIdentifier)
        
        collectionView.register(SPFamiliesCollectionViewCell.self, forCellWithReuseIdentifier: SPFamiliesCollectionViewCell.cellIdentifier)
        
        collectionView.register(SPFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SPFooterLoadingCollectionReusableView.identifier)
        
        
        return collectionView
    }()
    
    ///    Table view view models
    private var locationCellViewModels: [SPLocationTableViewCellViewModel] = []
    
    /// Collection view view models
    private var collectionViewCellViewModels: [any Hashable] = []
        
        // MARK: - init

        override init(frame: CGRect) {
            super.init(frame: frame)
            isHidden = true
            translatesAutoresizingMaskIntoConstraints = false
            addSubviews(tableView, collectionView)
            addConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func processViewModel() {
            guard let viewModel = viewModel else {
                return
            }
            
            switch viewModel.results {
            case .characters(let viewModels):
                self.collectionViewCellViewModels = viewModels
                setupCollectionView()
            case .episodes(let viewModels):
                self.collectionViewCellViewModels = viewModels
                setupCollectionView()
            case .locations(let viewModels):
                setupTableView(viewModels: viewModels)
            case .families(let viewModels):
                self.collectionViewCellViewModels = viewModels
                setupCollectionView()
            }
        }
        
    private func setupCollectionView() {
        tableView.isHidden = true
        collectionView.isHidden = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    private func setupTableView(viewModels: [SPLocationTableViewCellViewModel]) {
        tableView.delegate = self
        tableView.dataSource = self
        locationCellViewModels = viewModels
        collectionView.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
        
        //MARK: - Public
        
    public func configure(with viewModel: SPSearchResultsViewModel) {
            self.viewModel = viewModel
        }
}

// MARK: - Table View

extension SPSearchResultsView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SPLocationTableViewCell.cellIdentifier, for: indexPath) as? SPLocationTableViewCell else {
            fatalError("Failed to dequeue RMLocationTableViewCell")
        }
        cell.configure(with: locationCellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.spSearchResultsView(self, didTapLocationAt: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
// MARK: CollectionView

extension SPSearchResultsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        
        if let characterVM = currentViewModel as? SPCharacterCollectionViewCellViewModel {
            //Character Cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? SPCharacterCollectionViewCell else { fatalError() }
            cell.configure(with: characterVM)
            return cell
        } else if currentViewModel is SPCharacterEpisodeCollectionViewCellViewModel {
            // Episode Cell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? SPEpisodeCollectionViewCell else { fatalError() }
            
            if let episodeVM = currentViewModel as? SPCharacterEpisodeCollectionViewCellViewModel {
                cell.configure(with: episodeVM)
            }
            return cell
        }
        
        // Families Cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPFamiliesCollectionViewCell.cellIdentifier, for: indexPath) as? SPFamiliesCollectionViewCell else { fatalError() }
        
        if let episodeVM = currentViewModel as? SPFamiliesCollectionViewCellViewModel {
            cell.configure(with: episodeVM)
        }
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        let bounds = collectionView.bounds
        
        if currentViewModel is SPCharacterCollectionViewCellViewModel || currentViewModel is SPFamiliesCollectionViewCellViewModel {
            // Character size
            let width = (bounds.width-40)/2
            return CGSize(width: width, height: width * 1.3)
        }
        
        // Episode size
        let width = (bounds.width-20)
        return CGSize(width: width, height: width * 0.95)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else { fatalError("Unsupported")}
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SPFooterLoadingCollectionReusableView.identifier, for: indexPath) as? SPFooterLoadingCollectionReusableView else { fatalError("Unsupported") }
        if let viewModel = viewModel, viewModel.shouldShowLoadMoreIndicator {
            footer.startAnimating()
        }
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        //Hide the footer
        guard let viewModel = viewModel, viewModel.shouldShowLoadMoreIndicator else { return .zero}
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}
// MARK: -  Scrollview delegate

extension SPSearchResultsView: UIScrollViewDelegate {
    func scrollViewDidScroll
    (_ scrollView: UIScrollView) {
        if !locationCellViewModels.isEmpty {
            handleLocationPagination(scrollView)
        } else {
            handleCharacterOrEpisodePagination(scrollView: scrollView)
        }
    }
    
    private func handleCharacterOrEpisodePagination(scrollView: UIScrollView) {
        guard let viewModel = viewModel, !collectionViewCellViewModels.isEmpty, viewModel.shouldShowLoadMoreIndicator, !viewModel.isLoadingMoreResults else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                
                viewModel.fetchAdditionalResults { [weak self] newResults in
                    self?.tableView.tableFooterView = nil
                    self?.collectionViewCellViewModels  = newResults
                    print(newResults.count)
                }
            }
            t.invalidate()
        }
    }
    
    private func handleLocationPagination(_ scrollView: UIScrollView) {
        guard let viewModel = viewModel, !locationCellViewModels.isEmpty, viewModel.shouldShowLoadMoreIndicator, !viewModel.isLoadingMoreResults else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                DispatchQueue.main.async {
                    self?.showTableLoadingIndicator()
                }
                
                viewModel.fetchAdditionalLocations { [weak self] newResults in
                    self?.tableView.tableFooterView = nil
                    self?.locationCellViewModels  = newResults
                    self?.tableView.reloadData()
                }
            }
            t.invalidate()
        }
    }
    
    private func showTableLoadingIndicator() {
        let footer = SPTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
        tableView.tableFooterView = footer
    }
}


