//
//  SPLocationViewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 18.06.2023.
//

import Foundation

protocol SPLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class SPLocationViewViewModel {
    
    weak var delegate: SPLocationViewViewModelDelegate?
    
    private var locations: [SPLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = SPLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    // Location response info
    // Will contain next url, if present
    
    private var apiInfo: SPGetAllLocationsResponse.Links?
    
    public var cellViewModels: [SPLocationTableViewCellViewModel] = []
    
    init() {}
    
    public func location(at index: Int) -> SPLocation? {
        guard index < locations.count, index >= 0 else { return nil }
        return self.locations[index]
    }
    
    public func fetchLocations() {
        SPService.shared.execute(.listLocationsRequest, expecting: SPGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.links
                self?.locations = model.data
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(_):
                break
            }
        }
    }
    
    private var hasMoreResults: Bool {
        return false
    }
}
