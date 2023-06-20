//
//  SPLocationViewController.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import UIKit

/// Controller to show and search for Location
final class SPLocationViewController: UIViewController, SPLocationViewViewModelDelegate {
    
    private let primaryView = SPLocationView()
    
    private let viewModel = SPLocationViewViewModel()
    
    
//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
        title = "Locations"
        addSearchButton()
        addConstrains()
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    private func addConstrains() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTapSearch() {
        
    }
    
    //MARK: - LocationViewModel Delegate
    
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }
}
