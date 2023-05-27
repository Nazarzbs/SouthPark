//
//  SPCharacterEpisodeCollectionViewCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 23.05.2023.
//

import Foundation

//Define the signature of what data we need (kind of masking other properties)
protocol SPEpisodeDataRender {
    var name: String { get }
    var episode: Int { get }
    var season: Int { get }
    var air_date: String { get }
    var thumbnail_url: String { get }
    var description: String { get }
    
}

final class SPCharacterEpisodeCollectionViewCellViewModel {
    let episodeDataUrl: URL?

    private var isFetching = false
    private var dataBlock: ((SPEpisodeDataRender) -> Void)?
    private var episode: SPEpisodesData? {
        didSet {
            guard let model = episode?.data else {
                return
            }
           dataBlock?(model)
        }
    }

    //MARK: - Init
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
    
    //MARK: - Public
        
    //Publisher/subscriber pattern (one of the way)
    //Return RMEpisodeDataRender protocol to hide all other staff inside the model
    public func registerForData(_ block: @escaping (SPEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            //If we already fetch the data and user brings the cell back into view
            if let model = episode {
                self.dataBlock?(model.data)
            }
            return }
        guard let url = episodeDataUrl, let request = SPRequest(url: url) else { return }
        isFetching = true
        SPService.shared.execute(request, expected: SPEpisodesData.self) { [weak self] result in
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
}
 
