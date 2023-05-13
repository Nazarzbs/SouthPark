//
//  SPCharacterViewController.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import UIKit

/// Controller to show and search for Characters 
final class SPCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        //Check & in queryParameters
        let request = SPRequest(endpoint: .character, queryParameters: [URLQueryItem(name: "search", value: "eric")])
        
        print(request.url)
        
        SPService.shared.execute(request, expected: SPCharacter.self) { result in
           
        }
    }
}
