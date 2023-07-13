//
//  SPSearchResultViewModel.swift
//  SouthPark
//
//  Created by Nazar on 12.07.2023.
//

import Foundation

enum SPSearchResultsViewModel {
    case characters([SPCharacterCollectionViewCellViewModel])
    case episodes([SPCharacterEpisodeCollectionViewCellViewModel])
    case locations([SPLocationTableViewCellViewModel])
    case families([SPFamiliesCollectionViewCellViewModel])
}

