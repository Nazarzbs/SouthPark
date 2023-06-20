//
//  SPLocationTableViewCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 18.06.2023.
//

import Foundation
import UIKit

final class SPLocationTableViewCellViewModel: Hashable, Equatable {
    
    let location: SPLocations
  
    init(location: SPLocations) {
        self.location = location
    }
    
    public var name: String {
        return location.name
    }
    
    static func == (lhs: SPLocationTableViewCellViewModel, rhs: SPLocationTableViewCellViewModel) -> Bool {
        lhs.location.id == rhs.location.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
        
    }
    
    //@escaping - this cloture/call back can escape the context of another async job
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let imageUrlString = SPGetImageFromJsonLocalFile.shared.getImageUrlString(forCharacter: location.name, from: "LocationImages") else { return } 
        SPImageLoader.shared.downloadImage(imageUrlString, completion: completion)
    }
}
