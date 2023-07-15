//
//  SPSearchViewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 11.07.2023.
//

import Foundation

final class SPSearchViewViewModel {
    
    let config: SPSearchViewController.Config
    private var searchText = ""
    private var searchResultsHandler: ((SPSearchResultsViewModel) -> Void)?
    private var noResultsHandler: (() -> Void)?
    private var searchResultModel: Codable?
    
    // MARK: - init
    init(config: SPSearchViewController.Config) {
        self.config = config
    }
    
    //MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping (SPSearchResultsViewModel) -> Void) {
        self.searchResultsHandler = block
    }
    
    public func registerNoSearchResultHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }
    
    public func executeSearch() {
        
        let queryParams: [URLQueryItem] = [URLQueryItem(name: "search", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))]
       
        let request = SPRequest(endpoint: config.type.endpoint, queryParameters: queryParams)
        
        switch config.type.endpoint {
        case .characters:
            makeSearchAPICall(SPGetAllCharactersResponse.self, request: request)
        case .locations:
            makeSearchAPICall(SPGetAllLocationsResponse.self, request: request)
        case .episodes:
            makeSearchAPICall(SPGetAllEpisodesResponse.self, request: request)
        case .families:
            makeSearchAPICall(SPGetAllFamiliesResponse.self, request: request)
        }
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: SPRequest) {
        SPService.shared.execute(request, expecting: type) { [weak self] result in
            // Notify view of results, no results, or error
            switch result {
            case .success(let model):
                self?.processSearchResult(model: model)
            case .failure:
                self?.handleNoResults()
                break
            }
        }
    }
    
    private func processSearchResult(model: Codable) {
        var resultsVM: SPSearchResultsViewModel?
        if let characterResults = model as? SPGetAllCharactersResponse {
            resultsVM = .characters(characterResults.data.compactMap({
                return SPCharacterCollectionViewCellViewModel(characterName: $0.name, characterOccupation: $0.occupation ?? "Not given", characterImageName: $0.url, id: $0.id)
            }))
        } else if let episodesResults = model as? SPGetAllEpisodesResponse {
            resultsVM = .episodes(episodesResults.data.compactMap({
                return SPCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: "https://spapi.dev/api/episodes/" + "\($0.id)"))
            }))
        } else if let locationsResults = model as? SPGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.data.compactMap({
                return SPLocationTableViewCellViewModel(location: $0)
            }))
        } else if let familiesResults = model as? SPGetAllFamiliesResponse {
            guard let data = familiesResults.data.first else { return }
            resultsVM = .families(data.characters.compactMap({
                return SPFamiliesCollectionViewCellViewModel(characterDataUrl: URL(string: $0))
            }))
        }
        
        if let results = resultsVM {
            self.searchResultModel = model
            self.searchResultsHandler?(results)
        } else {
            handleNoResults()
        }
    }
    
    private func handleNoResults() {
        noResultsHandler?()
    }
    
    public func locationSearchResult(at index: Int) -> SPLocation? {
        guard let searchModel = searchResultModel as? SPGetAllLocationsResponse else { return nil }
        return searchModel.data[index]
    }
}
