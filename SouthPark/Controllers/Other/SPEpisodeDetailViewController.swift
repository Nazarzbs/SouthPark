//
//  SPEpisodeDetailViewController.swift
//  SouthPark
//
//  Created by Nazar on 05.06.2023.
//

import UIKit
import SafariServices
//Vc to show details about single episode
final class SPEpisodeDetailViewController: UIViewController, SPEpisodeDetailViewViewModelDelegate, SPEpisodeDetailViewDelegate {
   
    private let viewModel: SPEpisodeDetailViewViewModel
    
    private let detailView = SPEpisodeDetailView()
    
    //MARK: - Init

    init(url: URL?) {
        self.viewModel = SPEpisodeDetailViewViewModel(endpointURL: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.delegate = self
        title = "Episode"
       
        view.addSubview(detailView)
        addConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    @objc func didTapShare() {
        
    }
    //MARK: - View Delegate
    
    func spEpisodeDetailView(_ detailView: SPEpisodeDetailView, didSelect character: SPCharacter) {
        
        guard let imageUrlString = SPGetImageFromJsonLocalFile.shared.getImageUrlString(for: character.name, from: "CharactersImage" ) else { return }
        
        let vc = SPCharacterDetailViewController(viewModel: .init(character: character, imageUrl: imageUrlString))
        
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func spLocationDetailView(_ detailView: SPEpisodeDetailView, didSelect location: SPLocation) {
        guard let url = URL(string: "https://spapi.dev/api/locations/" + "\(location.id)") else { return }
        
        let vc = SPLocationDetailViewController(url: url)
        vc.title = location.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func spEpisodeWikiWebView(episodeUrl: URL) {
        let vc = SFSafariViewController(url: episodeUrl)
        present(vc, animated: true)
    }
    
    //MARK: - ViewModel delegate
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
}
