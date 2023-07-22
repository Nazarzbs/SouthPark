//
//  SPEpisodeDetailViewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 06.06.2023.
//

import UIKit

protocol SPEpisodeDetailViewViewModelDelegate: AnyObject {
     func didFetchEpisodeDetails()
}

final class SPEpisodeDetailViewViewModel {
    private let endpointURL: URL?
    private var dataTuple: (episode: SPEpisodesData, characters: [SPCharacter], locations: [SPLocation])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails() // Caller Will be our View and it will be notified to read data
        }
    }
    
    enum SectionType {
        case episodeImage(viewModel: SPEpisodeImageCollectionViewCellViewModel)
        case information(viewModels: [SPEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [SPCharacterCollectionViewCellViewModel])
        case description(viewModels: [SPEpisodeInfoCollectionViewCellViewModel])
        case wikiUrl(viewModels: [SPEpisodeInfoCollectionViewCellViewModel])
        case locations(viewModels: [SPEpisodeLocationsDetailCellViewModel])
    }
    
    public weak var delegate: SPEpisodeDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = [] // public but not allow to write to it only for reading
    
    // MARK: - init
     
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }
    
    //MARK: - Public
    // Fetch backing episode model
    public func fetchEpisodeData() {
        guard let url = endpointURL, let request = SPRequest(url: url) else { return }
        SPService.shared.execute(request, expecting: SPEpisodesData.self) { result in
            switch result {
            case .success(let model):
                self.fetchRelatedCharactersAndLocations(for: model)
            case .failure(_):
                break
            }
        }
    }
    
    
    public func wikiUrl() -> URL? {
        guard let dataTuple = dataTuple else { return nil }
        guard let url = URL(string: dataTuple.episode.data.wiki_url) else { return nil }
        return url
    }
    
    public func character(at index: Int) -> SPCharacter? {
        guard let dataTuple = dataTuple else { return nil }
        return dataTuple.characters[index]
    }
    
    public func location(at index: Int) -> SPLocation? {
        guard let dataTuple = dataTuple else { return nil }
        return dataTuple.locations[index]
    }
    
    //MARK: - Private
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        let episode = dataTuple.episode.data
        let characters = dataTuple.characters
        let locations = dataTuple.locations
        
        let config = UIImage.SymbolConfiguration(hierarchicalColor: .label)
        
        cellViewModels = [
            .episodeImage(viewModel: SPEpisodeImageCollectionViewCellViewModel(imageUrlString: episode.thumbnail_url)),
           
            .description(viewModels: [
                .init(title: "Description", value: episode.description, iconImageView: nil),
            ]),
            .wikiUrl(viewModels: [
                .init(title: "Wiki:", value: episode.wiki_url, iconImageView: nil )
            ]),
            .information(viewModels: [
                .init(title: "Name", value: episode.name, iconImageView: UIImage(systemName: "sparkles.tv", withConfiguration: config)),
                
                .init(title: "Air Date", value: episode.air_date, iconImageView: UIImage(systemName: "clock.circle", withConfiguration: config)),
                
                .init(title: "Episode", value: "Season: \(episode.season)\nEpisode: \(episode.episode)", iconImageView: UIImage(systemName: "tv.circle", withConfiguration: config)),
                
                .init(title: "Locations", value: "\(episode.locations.count)", iconImageView: UIImage(systemName: "globe.europe.africa", withConfiguration: config)),
                
                .init(title: "Characters", value: "\(episode.characters.count)", iconImageView: UIImage(systemName: "person.and.background.dotted", withConfiguration: config)),
            ]),
            .locations(viewModels: locations.compactMap({
                return SPEpisodeLocationsDetailCellViewModel(location: $0)
            })),
            .characters(viewModels: characters.compactMap({
                return SPCharacterCollectionViewCellViewModel(
                    characterName: $0.name, characterOccupation: $0.occupation ?? "Not given", characterImageName: $0.name, id: $0.id)
            }))
        ]
    }
    
    private func fetchRelatedCharactersAndLocations(for episode: SPEpisodesData) {
        let episodeRequests: [SPRequest] = episode.data.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return SPRequest(url: $0)
        })
        
        let locationRequests: [SPRequest] = episode.data.locations.compactMap({
            return URL(string: $0)
        }).compactMap({
            return SPRequest(url: $0)
        })
        
        //Dispatch group request for all element concurrently
        // 10 of parallel request
        // Notified once all done
        
        let group = DispatchGroup()
        var characters = [SPCharacter]()
        var locations = [SPLocation]()
        for request in episodeRequests {
           
            SPService.shared.execute(request, expecting: SPCharactersData.self, completion: {
                result in
                defer { //Last thing that going to run before the execution of our program exits the scope of this closure
//                    group.leave() // -20 // It is gona tell our group that what thing we kicked of and  started we left.
                }
                switch result {
                case .success(let model):
                    characters.append(model.data)
                case .failure:
                    break
                }
            })
        }
        
        for request in locationRequests {
            group.enter()
            SPService.shared.execute(request, expecting: SPLocationsData.self, completion: {
                result in
                defer { //Last thing that going to run before the execution of our program exits the scope of this closure
                    group.leave() // -20 // It is gona tell our group that what thing we kicked of and  started we left.
                }
                switch result {
                case .success(let model):
                    locations.append(model.data)
                case .failure:
                    break
                }
            })
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                episode: episode,
                characters: characters,
                locations: locations
            )
        }
    }
}
