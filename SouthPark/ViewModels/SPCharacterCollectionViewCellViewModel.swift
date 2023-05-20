//
//  SPCharacterCollectionViewCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 15.05.2023.
//

import Foundation

final class SPCharacterCollectionViewCellViewModel {
    // public - we will assign it directly
    public let characterName: String
    public let characterOccupation: String
    
    private let characterImageUrl: URL?
    
    init(characterName: String, characterOccupation: String, characterImageUrl: URL?) {
        self.characterName = characterName
        self.characterOccupation = characterOccupation
        self.characterImageUrl = characterImageUrl
    }
    
    public var characterOccupationText: String {
        return "Occupation: \(characterOccupation)"
    }
    
    //MARK: ToDO - fetch the image
    //@escaping - this cloture/call back can escape the context of another async job
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        //TODO: Abstract to Image Manager
        guard let url = characterImageUrl else { return completion(.failure(URLError(.badURL)))}
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
