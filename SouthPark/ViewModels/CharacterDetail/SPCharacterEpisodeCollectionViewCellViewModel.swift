//
//  SPCharacterEpisodeCollectionViewCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 23.05.2023.
//

import Foundation
import UIKit
//The required properties for episode data rendering.
//Define the signature of what data we need (kind of masking other properties)
protocol SPEpisodeDataRender {
    var name: String { get }
    var episode: Int { get }
    var season: Int { get }
    var air_date: String { get }
    var thumbnail_url: String { get }
    var description: String { get }
}

final class SPCharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {
    let episodeDataUrl: URL?

    //flag to track if data and images are being fetched
    private var isFetching = false
    
    //Property is a closure that allows other objects to register for episode data updates.
    private var dataBlock: ((SPEpisodeDataRender, Data?) -> Void)?
    
    private var episodeImageData: Data?
   
    //Property observer that updates the episode data and triggers the dataBlock closure to pass the updated data to subscribers.
    private var episode: SPEpisodesData? {
        didSet {
            guard let model = episode?.data else {
                return
            }
            fetchImage(data: model) { [weak self] result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.episodeImageData = data
                        self?.dataBlock?(model, data)
                    }
                case .failure(let error):
                    print("Error fetching thumbnail image: \(error)")
                }
            }
        }
    }
     
    //MARK: - Init
    //initialiser sets the initial values for the episodeDataUrl property.
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
    
    //MARK: - Public
        
    //Publisher/subscriber pattern
    //Return RMEpisodeDataRender protocol to hide all other staff inside the model
    //method allows other objects to subscribe to episode data updates by providing a closure to handle the updated data.
    public func registerForData(_ block: @escaping (SPEpisodeDataRender, Data?) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            //If we already fetch the data and user brings the cell back into view
            if let model = episode {
                self.dataBlock?(model.data, episodeImageData)
            }
            return }
        guard let url = episodeDataUrl, let request = SPRequest(url: url) else { return }
        isFetching = true
        
        SPService.shared.execute(request, expecting: SPEpisodesData.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
                
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    func fetchImage(data: SPEpisode?, completion: @escaping (Result<Data, Error>) -> Void) {

        guard let thumbnailURLString = data?.thumbnail_url else {
            // Handle the case when thumbnailURL is nil
            return
        }      
        guard let thumbnailURL = URL(string: thumbnailURLString) else { return }
        SPImageLoader.shared.downloadImage(thumbnailURL, completion: completion)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    
    static func == (lhs: SPCharacterEpisodeCollectionViewCellViewModel, rhs: SPCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
