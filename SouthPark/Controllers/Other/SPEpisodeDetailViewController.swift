//
//  SPEpisodeDetailViewController.swift
//  SouthPark
//
//  Created by Nazar on 05.06.2023.
//

import UIKit
//Vc to show details about single episode
final class SPEpisodeDetailViewController: UIViewController, SPEpisodeDetailViewViewModelDelegate {

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
    
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
}
