//
//  SPCharacterDetailViewController.swift
//  SouthPark
//
//  Created by Nazar on 20.05.2023.
//

import UIKit

/// Controller for show info about single character

final class SPCharacterDetailViewController: UIViewController {
    private let viewModel: SPCharacterDetailVIewViewModel
    
    init(viewModel: SPCharacterDetailVIewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
    }

}
