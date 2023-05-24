//
//  SPCharacterEpisodeCollectionViewCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 23.05.2023.
//

import Foundation

final class SPCharacterEpisodeCollectionViewCellViewModel {
    let episodeDataUrl: URL?
    
    init (episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
}
