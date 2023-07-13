//
//  SPSearchInputView.swift
//  SouthPark
//
//  Created by Nazar on 11.07.2023.
//

import UIKit

protocol SPSearchInputViewDelegate: AnyObject {
    func spSearchInputView(_ inputView: SPSearchInputView, didChangeSearchText text: String)
    func spSearchInputViewDidTapSearchKeyboardButton(_ inputView: SPSearchInputView)
}

final class SPSearchInputView: UIView {
    weak var delegate: SPSearchInputViewDelegate?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var viewModel: SPSearchInputViewViewModel?
    
    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(searchBar)
        addConstraints()
        
        searchBar.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 61),
        ])
    }
    
    public func configure(with viewModel: SPSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }
    
    public func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }
}

//MARK: - UISearchBarDelegate
extension SPSearchInputView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Notify delegate of change text
        print(searchText)
        delegate?.spSearchInputView(self, didChangeSearchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.spSearchInputViewDidTapSearchKeyboardButton(self)
        
    }
}

