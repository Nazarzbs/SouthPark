//
//  SPSearchViewController.swift
//  SouthPark
//
//  Created by Nazar on 10.06.2023.
//

import UIKit

class SPSearchViewController: UIViewController {
    
    struct Config {
        enum `Type` {
            case character
            case episode
            case location
            case family
            
            var title: String {
                switch self {
                case .character:
                    return "Search Characters"
                case .episode:
                    return "Search Episode"
                case .family:
                    return "Search Family"
                case .location:
                    return "Search Location"
                }
            }
        }
        
        let type: `Type`
    }
    
    private let config: Config
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = config.type.title
            view.backgroundColor = .systemBackground
    }
}
