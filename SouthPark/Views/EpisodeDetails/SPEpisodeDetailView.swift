//
//  SPEpisodeDetailView.swift
//  SouthPark
//
//  Created by Nazar on 06.06.2023.
//

import UIKit

protocol SPEpisodeDetailViewDelegate: AnyObject {
    func spEpisodeDetailView(_ detailView: SPEpisodeDetailView, didSelect character: SPCharacter)
}

final class SPEpisodeDetailView: UIView {
    
    public weak var delegate: (SPEpisodeDetailViewDelegate)?
    
    private var viewModel: SPEpisodeDetailViewViewModel? {
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
        collectionView.register(SPEpisodeImageCollectionViewCell.self, forCellWithReuseIdentifier: SPEpisodeImageCollectionViewCell.cellIdentifier)
        collectionView.register(SPEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: SPEpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(SPCharacterCollectionViewCell.self, forCellWithReuseIdentifier: SPCharacterCollectionViewCell.cellIdentifier)
        return collectionView
    }
    
    //MARK: - Public
    
    public func configure(with viewModel: SPEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
}

extension SPEpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else { return 0 }
        let sectionType = sections[section]
        
        switch sectionType {
        case .episodeImage(viewModel: _):
            return 1
        case .information(viewModels: let viewModels):
            return viewModels.count
        case .characters(viewModels: let viewModels):
            return viewModels.count
            //        case .locations(viewModels: let viewModels):
            //            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = viewModel?.cellViewModels else { fatalError("No view model") }
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
            
        case .information(viewModels: let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPEpisodeInfoCollectionViewCell.cellIdentifier, for: indexPath) as? SPEpisodeInfoCollectionViewCell else { fatalError() }
            cell.configure(with: cellViewModel)
            return cell
            
        case .characters(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? SPCharacterCollectionViewCell else { fatalError() }
            cell.configure(with: cellViewModel)
            return cell
        case .episodeImage(viewModel: let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPEpisodeImageCollectionViewCell.cellIdentifier, for: indexPath) as? SPEpisodeImageCollectionViewCell else { fatalError() }
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
        case .information:
            break
        case .characters:
            guard let character = viewModel.character(at: indexPath.row) else  { return }
            delegate?.spEpisodeDetailView(self, didSelect: character)
        case .episodeImage(viewModel: _):
            break
        }
    }
}

extension SPEpisodeDetailView {
    func layout(for section: Int) -> NSCollectionLayoutSection {
        
        guard let sections = viewModel?.cellViewModels else { return createInfoLayout() }
        
        switch sections[section] {
        case .information:
            return createInfoLayout()
        case .characters:
            return createCharacterLayout()
        case .episodeImage:
            return createEpisodeImageLayout()
        }
    }
    
    func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(260)) , subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createEpisodeImageLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(230)) , subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

