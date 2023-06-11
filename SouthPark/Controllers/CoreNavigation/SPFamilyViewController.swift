//
//  SPFamilieViewController.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import UIKit

/// Controller to show and search for Family
final class SPFamilyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Families"
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }
}
