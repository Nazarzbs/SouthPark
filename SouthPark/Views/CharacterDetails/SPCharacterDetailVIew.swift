//
//  SPCharacterDetailVIew.swift
//  SouthPark
//
//  Created by Nazar on 20.05.2023.
//

import UIKit

/// View for single character info
final class SPCharacterDetailVIew: UIView {
    
    public var collectionView: UICollectionView?
    
    private let viewModel: SPCharacterDetailVIewViewModel
 
    // anonymous closure
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    //MARK: - Init

    init(frame: CGRect, viewModel: SPCharacterDetailVIewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        viewModel.delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        addConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addConstrains() {
        guard let collectionView = collectionView else { return }
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(SPCharacterPhotoCollectionViewCell.self, forCellWithReuseIdentifier: SPCharacterPhotoCollectionViewCell.cellIdentifier)
        collectionView.register(SPCharacterInfoCollectionViewCell.self, forCellWithReuseIdentifier: SPCharacterInfoCollectionViewCell.cellIdentifier)
        collectionView.register(SPCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: SPCharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(SPCharacterRelativesCollectionViewCell.self, forCellWithReuseIdentifier: SPCharacterRelativesCollectionViewCell.cellIdentifier)
        
        collectionView.register(SPCharacterDetailSectionNameHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SPCharacterDetailSectionNameHeaderCollectionReusableView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        switch sectionTypes[sectionIndex] {
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .information:
            return viewModel.createInformationSectionLayout()
        case .episodes:
            return viewModel.createEpisodesSectionLayout()
        case .relatives:
            return viewModel.createCharacterLayout()
        }
    }
}

extension SPCharacterDetailVIew: SPCharacterDetailVIewViewModelDelegate {
    
    //Update episodes and family name after fetch 
    func didFetchFamilies() {
        DispatchQueue.main.async {
            self.collectionView?.reloadItems(at: [IndexPath(row: 6, section: 1), IndexPath(row: 0, section: 2), IndexPath(row: 1, section: 2), IndexPath(row: 2, section: 2)])
        }
    }
}
