//
//  SPEpisodeViewController.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//


import UIKit

/// Controller to show and search for Episode
final class SPEpisodeViewController: UIViewController, SPEpisodeListViewDelegate {
    
    // Declared as an optional without initialization.
    
    // When the tab button is tapped, the tabButtonTapped method is triggered. If viewModel is nil, indicating that it hasn't been initialized yet, it initializes viewModel with a new instance of ListViewViewModel and then proceeds to call fetchData to perform the data fetching.
    
    //  Using this approach, the viewModel is only created when needed, i.e., when the user taps on the navigation tab button. It gives you the flexibility to delay the initialization and data fetching until the appropriate time, optimizing resource usage and responsiveness.
    
    private var episodeListView: SPEpisodeListView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        episodeListView = SPEpisodeListView()
        setUpView()
       
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let vc = SPSearchViewController(config: .init(type: .episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setUpView() {
        guard let episodeListView = episodeListView else { return }
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
