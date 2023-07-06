//
//  SPFamiliesCollectionViewCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 03.07.2023.
//

import Foundation
import UIKit
//The required properties for episode data rendering.
//Define the signature of what data we need (kind of masking other properties)
protocol SPCharacterDataRender {
    var name: String { get }
    var id: Int { get }
    var occupation: String? { get }
}

protocol SPFamiliesCollectionViewCellViewModelDelegate: AnyObject {
    func didLoadInitialFamilies()
}

final class SPFamiliesCollectionViewCellViewModel: Hashable, Equatable {
    let characterDataUrl: URL?
    
    // Weak because we don't want to have leak memory
    public weak var delegate: SPFamiliesCollectionViewCellViewModelDelegate?

    //flag to track if data and images are being fetched
    private var isFetching = false
    
    //Property is a closure that allows other objects to register for episode data updates.
    private var dataBlock: ((SPCharacterDataRender, Data?) -> Void)?
    
    private var characterImageData: Data?
   
    //Property observer that updates the episode data and triggers the dataBlock closure to pass the updated data to subscribers.
    private var character: SPCharactersData? {
        didSet {
            guard let model = character?.data else {
                return
            }
            fetchImage(for: model.name) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.characterImageData = data
                        self.dataBlock?(model, data)
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self.dataBlock?(model, nil)
                        self.characterImageData = nil
                    }
                    print(String(describing: failure))
                }
            }
        }
    }
     
    //MARK: - Init
    //initialiser sets the initial values for the episodeDataUrl property.
    init(characterDataUrl: URL?) {
        self.characterDataUrl = characterDataUrl
    }
    
    //MARK: - Public
        
    //Publisher/subscriber pattern
    //Return RMEpisodeDataRender protocol to hide all other staff inside the model
    //method allows other objects to subscribe to episode data updates by providing a closure to handle the updated data.
    public func registerForData(_ block: @escaping (SPCharacterDataRender, Data?) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchCharacter() {
        guard !isFetching else {
            //If we already fetch the data and user brings the cell back into view
            if let model = character {
                self.dataBlock?(model.data, characterImageData)
            }
            return }
        guard let url = characterDataUrl, let request = SPRequest(url: url) else { return }
        isFetching = true
        SPService.shared.execute(request, expecting: SPCharactersData.self) { result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.character = model
                }
                
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    //@escaping - this cloture/call back can escape the context of another async job
    public func fetchImage(for characterName: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let imageUrl = SPGetImageFromJsonLocalFile.shared.getImageUrlString(for: characterName, from: "CharactersImage") else { return }
        SPImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.characterDataUrl?.absoluteString ?? "")
    }
    
    static func == (lhs: SPFamiliesCollectionViewCellViewModel, rhs: SPFamiliesCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

