//
//  SPFamiliesView.swift
//  SouthPark
//
//  Created by Nazar on 28.06.2023.
//

import UIKit

// to get method out of the View we use another delegate
protocol SPFamiliesViewDelegate: AnyObject {
    func didSelectFamiliesMember(_ character: SPCharacter)
}

final class SPFamiliesView: UIView {
    
    private let viewModel = SPFamiliesCollectionViewViewModel()
    public weak var delegate: SPFamiliesViewDelegate?
    
    public var collectionView: UICollectionView?
  
    // anonymous closure
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        viewModel.delegate = self
        viewModel.fetchFamilies()
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        collectionView.alpha = 0
        collectionView.isHidden = true
        addConstraint()
        spinner.startAnimating()
        setUpCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createFamiliesLayout()
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(FamilyNameFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FamilyNameFooterCollectionReusableView.identifier)
        
        collectionView.register(SPFamilyNameHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SPFamilyNameHeaderCollectionReusableView.identifier)
        
        collectionView.register(SPFamiliesCollectionViewCell.self, forCellWithReuseIdentifier: SPFamiliesCollectionViewCell.cellIdentifier)
        
        collectionView.register(SPFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SPFooterLoadingCollectionReusableView.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    private func setUpCollectionView() {
        collectionView?.dataSource = viewModel
        collectionView?.delegate = viewModel
    }
    
    private func addConstraint() {
        guard let collectionView = collectionView else { return }
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - Delegate

extension SPFamiliesView: SPFamiliesCollectionViewViewModelDelegate {
   
    //Now we did guarantee even if the async job takes significant amount of time we're never to end up in the case when view showed up before we got the data
    func didLoadInitialFamilies() {
        spinner.stopAnimating()
        collectionView?.isHidden = false
        collectionView?.reloadData() // Initial fetch
        
            UIView.animate(withDuration: 0.4) {
                self.collectionView?.alpha = 1
            }
    }
    
    func didLoadMoreFamilies(with newSectionIndexSet: IndexSet, and newIndexPaths: [IndexPath]) {
        // Add more cells
        collectionView?.performBatchUpdates {
            // Insert new sections
              collectionView?.insertSections(newSectionIndexSet)

              // Insert new items
              collectionView?.insertItems(at: newIndexPaths)
        }
    }
    
    func didSelectFamiliesMember(_ character: SPCharacter) {
        // to get method out of the View we use another delegate
        delegate?.didSelectFamiliesMember(character)
    }
    
    // MARK: - Layout
    
    func createFamiliesLayout() -> NSCollectionLayoutSection {
        
        var height: CGFloat = 0
        if UIDevice.isiPhone {
            height = 240
        } else {
            height = 480
        }
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 5, bottom: 20, trailing: 8)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.45), heightDimension: .estimated(height)), subitems: [item, item])
        
        // Define header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(100))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        // Define footer
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
        let footerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        let section = NSCollectionLayoutSection(group: group)
       
        section.boundarySupplementaryItems = [headerSupplementary, footerSupplementary]
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}
