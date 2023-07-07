//
//  CharacterListView.swift
//  SouthPark
//
//  Created by Nazar on 14.05.2023.
//

import UIKit

// to get method out of the View we use another delegate
protocol SPCharacterListViewDelegate: AnyObject {
    func spCharacterListView(didSelectCharacter character: SPCharacter)
}

/// View that handles showing list of characters, loaded, etc.
final class SPCharacterListView: UIView {
    
    public weak var delegate: SPCharacterListViewDelegate?
    private let viewModel = SPCharacterListViewViewModel()
    
    // anonymous closure
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(SPCharacterCollectionViewCell.self, forCellWithReuseIdentifier: SPCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(SPFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SPFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        
        addConstraint()
        spinner.startAnimating()
        // viewModel.delegate = self - call it to tell our collection view to reload once that data has been updated
        viewModel.delegate = self
        
        viewModel.fetchCharacters()
        setUpCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraint() {
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
    
    private func setUpCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel 
    }
}

extension SPCharacterListView: SPCharacterListViewViewModelDelegate {
    func didSelectCharacter(_ character: SPCharacter) {
        // to get method out of the View we use another delegate
        delegate?.spCharacterListView(didSelectCharacter: character)
    }
    
    //Now we did guarantee even if the async job takes significant amount of time we're never to end up in the case when view showed up before we got the data
    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData() // Initial fetch
        
            UIView.animate(withDuration: 0.4) {
                self.collectionView.alpha = 1
            }
    }

    func didLoadMoreCharacters(with newIndexPaths: [IndexPath]) {
        // Add more cells
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
}
