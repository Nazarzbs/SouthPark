//
//  SPSearchView.swift
//  SouthPark
//
//  Created by Nazar on 11.07.2023.
//

import UIKit

final class SPSearchView: UIView {
    
    let viewModel: SPSearchViewViewModel
    
    // MARK: - Subviews
    // Search input view (bar, selection buttons)
    // No results view
    // Result collection
    
    //MARK: - init

    init(frame: CGRect, viewModel: SPSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .red
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - collection view

extension SPSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
