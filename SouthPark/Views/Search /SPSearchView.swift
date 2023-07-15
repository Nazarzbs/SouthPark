//
//  SPSearchView.swift
//  SouthPark
//
//  Created by Nazar on 11.07.2023.
//

import UIKit

protocol SPSearchViewDelegate: AnyObject {
    func spSearchView(_ searchView: SPSearchView, didSelectOption location: SPLocation)
}

final class SPSearchView: UIView {
    
    let viewModel: SPSearchViewViewModel
    
    weak var delegate: SPSearchViewDelegate?
    
    // MARK: - Subviews

    private let searchInputView  = SPSearchInputView()
    
    private let noResultsView = SPNoSearchResultsView()
    // Result collection
    
    private let resultsView = SPSearchResultsView()
    
    //MARK: - init

    init(frame: CGRect, viewModel: SPSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultsView, noResultsView, searchInputView)
        addConstraints()
        searchInputView.configure(with: SPSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        resultsView.delegate = self
        setupHandlers()
    }
    private func setupHandlers() {
        
        // Subscribe to the handler, invoke after created view model
        viewModel.registerSearchResultHandler { [weak self] results in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: results)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        
        viewModel.registerNoSearchResultHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
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
            
            // Search results view
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            resultsView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
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

extension SPSearchView: SPSearchResultsViewDelegate {
    func spSearchResultsView(_ resultsView: SPSearchResultsView, didTapLocationAt index: Int) {
        print("location Tapped")
        
        guard let locationModel = viewModel.locationSearchResult(at: index) else { return }
        
        delegate?.spSearchView(self, didSelectOption: locationModel)
    }
}

