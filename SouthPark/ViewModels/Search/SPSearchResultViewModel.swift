//
//  SPSearchResultViewModel.swift
//  SouthPark
//
//  Created by Nazar on 12.07.2023.
//

import Foundation

// Abstracted our View model to be a struct instead enum that give ability to have property and methods 
final class SPSearchResultsViewModel {
    public private(set) var results: SPSearchResultsType
    let next: String?
    
    init(results: SPSearchResultsType, next: String?) {
        self.results = results
        self.next = next
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public private(set) var isLoadingMoreResults = false
    
    public func fetchAdditionalLocations(completion: @escaping ([SPLocationTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else { return }
        
        guard let nextUrlString = next, let url = URL(string: nextUrlString) else { return }
        
        isLoadingMoreResults = true
        
        guard let request = SPRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        // Translate URL to urlRequest
        SPService.shared.execute(request, expecting: SPGetAllLocationsResponse.self) { [weak self] result in
            //change the self to avoid nil
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.data
                let info = responseModel.links
                
                let additionalLocations = moreResults.compactMap({
                    return SPLocationTableViewCellViewModel(location: $0)
                })
                var newResults: [SPLocationTableViewCellViewModel] = []
                switch strongSelf.results {
                case .locations(let existingResults):
                    newResults = existingResults + additionalLocations
                    strongSelf.results = .locations(newResults)
                    break
                case .characters(_):
                    break
                case .episodes(_):
                    break
                case .families(_):
                    break
                }
               
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false
                    
                    // Notify via callback
                    completion(newResults)
//                    strongSelf.didFinishPagination?()
                }
                
            case .failure(let failure):
                self?.isLoadingMoreResults = false
                print(String(describing: failure))
            }
        }
    }
    
    public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        guard !isLoadingMoreResults else { return }
        
        guard let nextUrlString = next, let url = URL(string: nextUrlString) else { return }
        
        isLoadingMoreResults = true
        
        guard let request = SPRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        switch results {
        case .characters(let existingResults):
            // Translate URL to urlRequest
            SPService.shared.execute(request, expecting: SPGetAllCharactersResponse.self) { [weak self] result in
                //change the self to avoid nil
                guard let strongSelf = self else { return }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.data
                    let info = responseModel.links
                    
                    let additionalResults = moreResults.compactMap({
                        return SPCharacterCollectionViewCellViewModel(characterName: $0.name, characterOccupation: $0.occupation ?? "Not given", characterImageName: $0.name, id: $0.id)
                    })
                    var newResults: [SPCharacterCollectionViewCellViewModel] = []
                    
                    newResults = existingResults + additionalResults
                    strongSelf.results = .characters(newResults)
                   
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        
                        // Notify via callback
                        completion(newResults)
    //                    strongSelf.didFinishPagination?()
                    }
                    
                case .failure(let failure):
                    self?.isLoadingMoreResults = false
                    print(String(describing: failure))
                }
            }
        case .episodes(let existingResults):
            // Translate URL to urlRequest
            SPService.shared.execute(request, expecting: SPGetAllEpisodesResponse.self) { [weak self] result in
                //change the self to avoid nil
                guard let strongSelf = self else { return }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.data
                    let info = responseModel.links
                    
                    let additionalResults = moreResults.compactMap({
                        return SPCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: "https://spapi.dev/api/episodes/" + "\($0.id)"))
                    })
                    var newResults: [SPCharacterEpisodeCollectionViewCellViewModel] = []
                    newResults = existingResults + additionalResults
                    strongSelf.results = .episodes(newResults)
                   
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        
                        // Notify via callback
                        completion(newResults)
                    }
                    
                case .failure(let failure):
                    self?.isLoadingMoreResults = false
                    print(String(describing: failure))
                }
            }
        case .locations(_):
            break
        case .families(_):
                //Table view case
            break
        }
    }
    
    func fetchAdditionalResults() {
        
    }
}

enum SPSearchResultsType {
    case characters([SPCharacterCollectionViewCellViewModel])
    case episodes([SPCharacterEpisodeCollectionViewCellViewModel])
    case locations([SPLocationTableViewCellViewModel])
    case families([SPFamiliesCollectionViewCellViewModel])
}

