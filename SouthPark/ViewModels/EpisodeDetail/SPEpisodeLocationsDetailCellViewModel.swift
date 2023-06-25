//
//  SPEpisodeLocationsDetailCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 25.06.2023.
//

import Foundation

final class SPEpisodeLocationsDetailCellViewModel {
    
    public var locationName: String
    
    private var location: SPLocation
    
    init(location: SPLocation) {
        self.location = location
        self.locationName = location.name
    }
    
    //@escaping - this cloture/call back can escape the context of another async job
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let imageUrlString = SPGetImageFromJsonLocalFile.shared.getImageUrlString(for: location.name, from: "LocationImages") else { return }
        SPImageLoader.shared.downloadImage(imageUrlString, completion: completion)
    }
    
}
