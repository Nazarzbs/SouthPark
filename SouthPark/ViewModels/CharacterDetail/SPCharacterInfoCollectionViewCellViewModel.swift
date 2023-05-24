//
//  SPCharacterInfoCollectionViewCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 23.05.2023.
//

import Foundation

final class SPCharacterInfoCollectionViewCellViewModel {
    public let value: String
    public let title: String
    
    init (value: String, title: String) {
        self.value = value
        self.title = title
    }
}
