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
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public var isLoadingMoreLocations = false
    
    private var didFinishPagination: (() -> Void)?
    
//MARK: - init
    init() {}
    
    public func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
    }
    
    /// Paginate if additional locations are needed
    public func fetchAdditionalLocations() {
        guard !isLoadingMoreLocations else { return }
        
        guard let nextUrlString = apiInfo?.next, let url = URL(string: nextUrlString) else { return }
        
        isLoadingMoreLocations = true
        
        guard let request = SPRequest(url: url) else {
            isLoadingMoreLocations = false
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
                
                strongSelf.apiInfo = info
                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return SPLocationTableViewCellViewModel(location: $0)
                }))
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreLocations = false
                    
                    // Notify via callback
                    strongSelf.didFinishPagination?()
                }
            case .failure(let failure):
                self?.isLoadingMoreLocations = false
                print(String(describing: failure))
            }
        }
    }
    
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
