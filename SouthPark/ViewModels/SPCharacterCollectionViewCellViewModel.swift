//
//  SPCharacterCollectionViewCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 15.05.2023.
//

import Foundation

final class SPCharacterCollectionViewCellViewModel: Hashable, Equatable {
    // public - we will assign it directly
    public let characterName: String
    public let characterOccupation: String
    public let id: Int?
    
    private let characterImageUrl: URL?
    
    init(characterName: String, characterOccupation: String, characterImageUrl: URL?, id: Int?) {
        self.characterName = characterName
        self.characterOccupation = characterOccupation
        self.characterImageUrl = characterImageUrl
        self.id = id
    }
    
    public var characterOccupationText: String {
        return "Occupation: \(characterOccupation)"
    }
    
    //MARK: ToDO - fetch the image
    //@escaping - this cloture/call back can escape the context of another async job
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        //TODO: Abstract to Image Manager
        guard let url = characterImageUrl else { return completion(.failure(URLError(.badURL)))}
        SPImageLoader.shared.downloadImage(url, completion: completion)
    }
    
    //MARK: - Hashable
    
    static func == (lhs: SPCharacterCollectionViewCellViewModel, rhs: SPCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        //Telling view model what unique hash value for if is
        hasher.combine(characterName)
        hasher.combine(characterOccupation)
        hasher.combine(characterImageUrl)
        hasher.combine(id)
    }
}
