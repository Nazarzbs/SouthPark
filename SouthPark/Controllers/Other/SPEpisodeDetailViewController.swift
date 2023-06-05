//
//  SPEpisodeDetailViewController.swift
//  SouthPark
//
//  Created by Nazar on 05.06.2023.
//

import UIKit
//Vc to show details about single episode
final class SPEpisodeDetailViewController: UIViewController {
   
    private let url: URL?
    
    //MARK: - Init

    init(url: URL?) {
        self.url = url
    
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        
        view.backgroundColor = .blue
    }
}
