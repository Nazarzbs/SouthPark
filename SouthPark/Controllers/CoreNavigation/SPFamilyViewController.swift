//
//  SPFamilieViewController.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import UIKit

/// Controller to show and search for Family
final class SPFamilyViewController: UIViewController, SPFamiliesViewDelegate {
  
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
        familyView.delegate = self
        view.addSubview(familyView)
        NSLayoutConstraint.activate([
            familyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            familyView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            familyView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            familyView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - Delegate
    
    func didSelectFamiliesMember(_ character: SPCharacter) {
        // open detail controller for that character
        guard let imageURL = SPGetImageFromJsonLocalFile.shared.getImageUrlString(for: character.name, from: "CharactersImage") else { return }
        
        let viewModel = SPCharacterDetailVIewViewModel(character: character, imageUrl: imageURL)
        let detailVC = SPCharacterDetailViewController(viewModel: viewModel)
        //navigationController give us animated slide by default
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
