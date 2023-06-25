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
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
        let vc = SPSearchViewController(config: SPSearchViewController.Config(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
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
    
    func spCharacterListView(_ characterListView: SPCharacterListView, didSelectCharacter character: SPCharacter) {
        // open detail controller for that character
        guard let imageURL = SPGetImageFromJsonLocalFile.shared.getImageUrlString(for: character.name, from: "CharactersImage") else { return }
        
        let viewModel = SPCharacterDetailVIewViewModel(character: character, imageUrl: imageURL)
        let detailVC = SPCharacterDetailViewController(viewModel: viewModel)
        //navigationController give us animated slide by default
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }    
}
