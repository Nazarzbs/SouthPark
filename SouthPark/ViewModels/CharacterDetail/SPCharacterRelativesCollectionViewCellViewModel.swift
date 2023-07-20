//
//  SPCharacterRelativesCollectionViewCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 20.07.2023.
//

import Foundation

final class SPCharacterRelativesCollectionViewCellViewModel {
    public let relation: String
    
    //Property is a closure that allows other objects to register for episode data updates.
    private var dataBlock: ((SPCharacter, Data?) -> Void)?
    private var characterImageData: Data?
    private let characterUrlString: String
    
    //Property observer that updates the episode data and triggers the dataBlock closure to pass the updated data to subscribers.
    private var character: SPCharacter? {
        didSet {
            guard let character = character else { return }
            
            fetchImage() { [weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.dataBlock?(character, data)
                    }
                case .failure(let error):
                    print("Error fetching thumbnail image: \(error)")
                }
            }
        }
    }
    
    //MARK: - Init
    
    init(relation: String, characterUrlString: String) {
        self.relation = relation
        self.characterUrlString = characterUrlString
    }
    
    //MARK: - Public
        
    //Publisher/subscriber pattern
    //Return RMEpisodeDataRender protocol to hide all other staff inside the model
    //method allows other objects to subscribe to episode data updates by providing a closure to handle the updated data.
    public func registerForData(_ block: @escaping (SPCharacter, Data?) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchCharacters() {
        guard let url = URL(string: characterUrlString), let request = SPRequest(url: url) else { return }
        SPService.shared.execute(request, expecting: SPCharactersData.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                DispatchQueue.main.async {
                    self?.character = responseModel.data
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let character = character else { return }
        
        guard let imageUrlString = SPGetImageFromJsonLocalFile.shared.getImageUrlString(for: character.name, from: "CharactersImage") else { return }
        SPImageLoader.shared.downloadImage(imageUrlString, completion: completion)
    }
}
