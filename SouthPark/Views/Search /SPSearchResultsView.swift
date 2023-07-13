//
//  SPSearchResultsView.swift
//  SouthPark
//
//  Created by Nazar on 13.07.2023.
//

import UIKit

/// Shows search results UI
class SPSearchResultsView: UIView {
    
    private var viewModel: SPSearchResultsViewModel? {
            didSet {
                self.processViewModel()
            }
        }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(SPLocationTableViewCell.self, forCellReuseIdentifier: SPLocationTableViewCell.cellIdentifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
        
        // MARK: - init

        override init(frame: CGRect) {
            super.init(frame: frame)
            isHidden = true
            translatesAutoresizingMaskIntoConstraints = false
            addSubviews(tableView)
            addConstraints()           
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func processViewModel() {
            guard let viewModel = viewModel else {
                return
            }
            
            switch viewModel {
            case .characters(let viewModels):
                setupCollectionView()
            case .episodes(let viewModels):
                setupCollectionView()
            case .locations(let viewModels):
                setupTableView()
            case .families(let viewModels):
                setupCollectionView()
            }
        }
        
    private func setupCollectionView() {
        
    }
    
    private func setupTableView() {
        tableView.isHidden = false
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        tableView.backgroundColor = .yellow
    }
        
        //MARK: - Public
        
    public func configure(with viewModel: SPSearchResultsViewModel) {
            self.viewModel = viewModel
        }
}
