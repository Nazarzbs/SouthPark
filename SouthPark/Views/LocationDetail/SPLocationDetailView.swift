//
//  SPLocationDetailView.swift
//  SouthPark
//
//  Created by Nazar on 21.06.2023.
//

import UIKit

protocol SPLocationDetailViewDelegate: AnyObject {
    func spLocationDetailView(_ detailView: SPLocationDetailView, didSelect episode: SPEpisode)
}

final class SPLocationDetailView: UIView {
    
    public weak var delegate: (SPLocationDetailViewDelegate)?
    
    private var viewModel: SPLocationDetailViewViewModel? {
        didSet {
            spinner.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.collectionView?.alpha = 1
            }
        }
    }
    
    private var collectionView: UICollectionView?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var numberOfEpisodes = 0
    //MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
       // backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        addSubviews(collectionView, spinner)
        self.collectionView = collectionView
        addConstraint()
        
        spinner.startAnimating()
     }
     
     required init?(coder: NSCoder) {
         fatalError("Unsupported")
     }
    
    private func addConstraint() {
        guard let collectionView = collectionView else { return }
        
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
      
        collectionView.register(SPLocationEpisodesCollectionViewCell.self, forCellWithReuseIdentifier: SPLocationEpisodesCollectionViewCell.cellIdentifier)
        
        collectionView.register(SPLocationDetailCollectionViewCell.self, forCellWithReuseIdentifier: SPLocationDetailCollectionViewCell.cellIdentifier)
        collectionView.register(SPLocationDetailSectionNameHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SPLocationDetailSectionNameHeaderCollectionReusableView.identifier)
       
        return collectionView
    }
    
    //MARK: - Public
    
    public func configure(with viewModel: SPLocationDetailViewViewModel) {
        self.viewModel = viewModel
    }
}

extension SPLocationDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {   
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else { return 0 }
        let sectionType = sections[section]
        
        switch sectionType {
        case .episodes(viewModels: let viewModels):
            numberOfEpisodes = viewModels.count
            return viewModels.count
        case .location(viewModel: _):
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = viewModel?.cellViewModels else { fatalError("No view model") }
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
            
        case .episodes(viewModels: let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPLocationEpisodesCollectionViewCell.cellIdentifier, for: indexPath) as? SPLocationEpisodesCollectionViewCell else { fatalError() }
            cell.configure(with: cellViewModel)
            return cell
        case .location(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPLocationDetailCollectionViewCell.cellIdentifier, for: indexPath) as? SPLocationDetailCollectionViewCell else { fatalError() }
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let viewModel = viewModel else { return }

        let sections = viewModel.cellViewModels
        let sectionType = sections[indexPath.section]

        switch sectionType {
        case .episodes:
            guard let episode = viewModel.episode(at: indexPath.row) else { return }
            delegate?.spLocationDetailView(self, didSelect: episode)
        case .location:
            break
        }
    }
    
    // MARK: - Supplementary view header
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SPLocationDetailSectionNameHeaderCollectionReusableView.identifier, for: indexPath) as! SPLocationDetailSectionNameHeaderCollectionReusableView
        header.label.text = "Episodes"
        return header
    }
}

extension SPLocationDetailView {
    func layout(for section: Int) -> NSCollectionLayoutSection {
        
        guard let sections = viewModel?.cellViewModels else { return createLocationLayout() }
        
        switch sections[section] {
        case .location:
            return createLocationLayout()
        case .episodes:
            return createEpisodesLayout()
        }
    }
    
    func createEpisodesLayout() -> NSCollectionLayoutSection {
        var fractionalWidth: CGFloat = 0
        var height: CGFloat = 0
        if UIDevice.isiPhone {
            height = 125
            fractionalWidth = 0.5
        } else {
            fractionalWidth = 0.33
            height = 270
        }
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionalWidth), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(height)), subitems: [item, item, item])
        let section = NSCollectionLayoutSection(group: group)
        
        // Define header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(numberOfEpisodes == 0 ? 0 : 100))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerSupplementary]
        return section
    }
    
    func createLocationLayout() -> NSCollectionLayoutSection {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-40)
        
        var height: CGFloat = 0
        if UIDevice.isiPhone {
            height = 205
        } else {
            height = width * 0.75
        }
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(height)) , subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

