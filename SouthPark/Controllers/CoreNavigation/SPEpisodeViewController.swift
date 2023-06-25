//
//  SPEpisodeViewController.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import UIKit

/// Controller to show and search for Episode
final class SPEpisodeViewController: UIViewController, SPEpisodeListViewDelegate {
    
    private let episodeListView = SPEpisodeListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        setUpView()
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        
    }
    
    private func setUpView() {
        episodeListView.delegate = self
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //Mark: - RMEpisodeListViewDelegate
    
    func spEpisodeListView(_ episodeListView: SPEpisodeListView, didSelectEpisode episode: SPEpisode) {
        //Open detail controller for that episode
        let detailVC = SPEpisodeDetailViewController(url: URL(string: "https://spapi.dev/api/episodes/" + "\(episode.id)"))
        
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
