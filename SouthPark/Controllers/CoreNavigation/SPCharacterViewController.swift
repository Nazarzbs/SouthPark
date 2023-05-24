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
    
    func spCharacterListView(_ characterListView: SPCharacterListView, didSelectCharacter character: SPCharacter) {
        // open detail controller for that character
        guard let jsonData = SPGetImageFromJsonLocalFile.shared.readLocalFile(forName: "CharactersImage") else { return print("Json data is missing!")}
        let characterImageUrls = SPGetImageFromJsonLocalFile.shared.parse(jsonData)
        let imageURL = characterImageUrls?.images.filter {
            $0.title == character.name
        }
        let unscaledCharacterImageURL = SPGetImageFromJsonLocalFile.shared.getUnscaledImageURL(from: imageURL)
        print(unscaledCharacterImageURL)
        let viewModel = SPCharacterDetailVIewViewModel(character: character, image: unscaledCharacterImageURL)
        let detailVC = SPCharacterDetailViewController(viewModel: viewModel)
        //navigationController give us animated slide by default
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }    
}
