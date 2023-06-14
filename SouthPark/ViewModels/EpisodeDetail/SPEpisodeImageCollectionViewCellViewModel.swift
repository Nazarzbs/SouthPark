//
//  SPEpisodeImageCollectionViewCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 14.06.2023.
//

import Foundation
import UIKit

struct SPEpisodeImageCollectionViewCellViewModel {
    public let imageUrlString: String
    
    //@escaping - this cloture/call back can escape the context of another async job
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        //TODO: Abstract to Image Manager
        
        guard let imageUrl = URL(string: imageUrlString) else { return }
        
        SPImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
}
