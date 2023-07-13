//
//  SPSearchInputViewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 11.07.2023.
//

import Foundation

final class SPSearchInputViewViewModel {
    private let type: SPSearchViewController.Config.`Type`
    
    init(type: SPSearchViewController.Config.`Type`) {
        self.type = type
    }
    
    //MARK: - Public
    
    public var searchPlaceholderText: String {
        switch self.type {
        case .character:
            return "Character Name"
        case .location:
            return "Location Name"
        case .episode:
            return "Episode Title"
        case .family:
            return "Family Name"
        }
    }
}
