//
//  SPCharacterDetailVIewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 20.05.2023.
//

import Foundation

final class SPCharacterDetailVIewViewModel {
    
    private let character: SPCharacter
    
    init(character: SPCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
