//
//  SPCharacterPhotoCollectionViewCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 23.05.2023.
//

import Foundation

final class SPCharacterPhotoCollectionViewCellViewModel {
    
    //To store specific cell view model we use Associated Value with enum cases.
    public let imageUrl: URL?
    
    init (imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        SPImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
}
