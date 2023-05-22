//
//  SPCharacterViewController.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import UIKit

/// Controller to show and search for Characters 
final class SPCharacterViewController: UIViewController, SPCharacterListViewDelegate {
    

    private let characterListView = SPCharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setUpView()
    }
    
    private func setUpView() {
        // Make that controller dele
        characterListView.delegate = self
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - SPCharacterListViewDelegate
    
    func rmCharacterListView(_ characterListView: SPCharacterListView, didSelectCharacter character: SPCharacter) {
        // open detail controller for that character
        let viewModel = SPCharacterDetailVIewViewModel(character: character)
        let detailVC = SPCharacterDetailViewController(viewModel: viewModel)
        //navigationController give us animated slide by default
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }    
}
