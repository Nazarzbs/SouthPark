//
//  SPLocationDetailViewController.swift
//  SouthPark
//
//  Created by Nazar on 21.06.2023.
//

import UIKit

//Vc to show details about single episode
final class SPLocationDetailViewController: UIViewController, SPLocationDetailViewViewModelDelegate, SPLocationDetailViewDelegate {

    private let viewModel: SPLocationDetailViewViewModel
    
    private let detailView = SPLocationDetailView()
    
    //MARK: - Init

    init(url: URL?) {
        self.viewModel = SPLocationDetailViewViewModel(endpointURL: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.delegate = self
        title = "Location"
       
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
    
    func spLocationDetailView(_ detailView: SPLocationDetailView, didSelect episode: SPEpisode) {
    
        let vc = SPEpisodeDetailViewController(url: URL(string: "https://spapi.dev/api/episodes/" + "\(episode.id)"))
        vc.title = episode.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: - ViewModel delegate
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
}

