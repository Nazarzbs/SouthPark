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
    
    //MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
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
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200)) , subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createLocationLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(280)) , subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

