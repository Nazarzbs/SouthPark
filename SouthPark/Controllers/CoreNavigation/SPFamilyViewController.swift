//
//  SPFamilieViewController.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import UIKit

/// Controller to show and search for Family
final class SPFamilyViewController: UIViewController {
    
    private var familyView: SPFamiliesView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Families"
        addSearchButton()
        familyView = SPFamiliesView()
        setUpView()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }
    
    private func setUpView() {
        guard let familyView = familyView else { return }
        
        view.addSubview(familyView)
        NSLayoutConstraint.activate([
            familyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            familyView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            familyView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            familyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
