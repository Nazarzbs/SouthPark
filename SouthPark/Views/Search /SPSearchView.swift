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

    private let searchInputView  = SPSearchInputView()
    
    private let noResultsView = SPNoSearchResultsView()
    // Result collection
    
    //MARK: - init

    init(frame: CGRect, viewModel: SPSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView, searchInputView)
        addConstraints()
        searchInputView.configure(with: SPSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            // Search input view
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: 61),
            
            //No results
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
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

// MARK: - SPSearchInputViewDelegate

extension SPSearchView: SPSearchInputViewDelegate {
    func spSearchInputViewDidTapSearchKeyboardButton(_ inputView: SPSearchInputView) {
        viewModel.executeSearch()
    }
    
    func spSearchInputView(_ inputView: SPSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
}
