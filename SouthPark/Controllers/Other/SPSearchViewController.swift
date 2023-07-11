//
//  SPSearchViewController.swift
//  SouthPark
//
//  Created by Nazar on 10.06.2023.
//

import UIKit

class SPSearchViewController: UIViewController {
    
    struct Config {
        enum `Type` {
            case character
            case episode
            case location
            case family
            
            var title: String {
                switch self {
                case .character:
                    return "Search Characters"
                case .episode:
                    return "Search Episode"
                case .family:
                    return "Search Family"
                case .location:
                    return "Search Location"
                }
            }
        }
        
        let type: `Type`
    }
    
    private let viewModel: SPSearchViewViewModel
    private let searchView: SPSearchView
    
    init(config: Config) {
        let viewModel = SPSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = SPSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = viewModel.config.type.title
            view.backgroundColor = .systemBackground
            view.addSubview(searchView)
            addConstrains()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(didTapExecuteSearch))
    }
    
    @objc
    private func didTapExecuteSearch() {
       // viewModel.executeSearch()
    }
    
    
    private func addConstrains() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
