//
//  SPLocationDetailViewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 21.06.2023.
//

import Foundation

protocol SPLocationDetailViewViewModelDelegate: AnyObject {
     func didFetchLocationDetails()
}

final class SPLocationDetailViewViewModel {
    private let endpointURL: URL?
    private var dataTuple: (location: SPLocation, episodes: [SPEpisode])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails() // Caller Will be our View and it will be notified to read data
        }
    }
    
    enum SectionType {
        case location(viewModel: SPLocationTableViewCellViewModel)
        case episodes(viewModels: [SPLocationEpisodesDetailCellViewModel])
    }
    
    public weak var delegate: SPLocationDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = [] // public but not allow to write to it only for reading
    
    // MARK: - init
     
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }
    
    //MARK: - Public
    // Fetch backing episode model
    public func fetchEpisodeData() {
        
        guard let url = endpointURL, let request = SPRequest(url: url) else { return }
        SPService.shared.execute(request, expecting: SPLocationsData.self) { result in
            switch result {
            case .success(let model):
                self.fetchRelatedEpisodes(location: model.data)
            case .failure(_):
                break
            }
        }
    }
    
    public func episode(at index: Int) -> SPEpisode? {
        guard let dataTuple = dataTuple else { return nil }
        return dataTuple.episodes[index]
    }
    
    //MARK: - Private
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        let location = dataTuple.location
        let episodes = dataTuple.episodes
        cellViewModels = [
            .location(viewModel: SPLocationTableViewCellViewModel(location: location)),
            .episodes(viewModels: episodes.compactMap({
                return SPLocationEpisodesDetailCellViewModel(episodeDataUrl: URL(string: "https://spapi.dev/api/episodes/" + "\($0.id)"))
            }))
        ]
    }
    
    private func fetchRelatedEpisodes(location: SPLocation) {
       
        let requests: [SPRequest] = location.episodes.compactMap({
            return URL(string: $0)
        }).compactMap({
            return SPRequest(url: $0)
        })
        
        //Dispatch group request for all element concurrently
        // 10 of parallel request
        // Notified once all done
        
        let group = DispatchGroup()
        var episodes = [SPEpisode]()
        for request in requests {
            group.enter()
            SPService.shared.execute(request, expecting: SPEpisodesData.self, completion: {
                result in
                defer { //Last thing that going to run before the execution of our program exits the scope of this closure
                    group.leave() // -20 // It is gona tell our group that what thing we kicked of and  started we left.
                }
                switch result {
                case .success(let model):
                    episodes.append(model.data)
                case .failure:
                    break
                }
            })
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                location: location,
                episodes: episodes
            )
        }
    }
}
