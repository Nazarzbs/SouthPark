//
//  SPLocationViewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 18.06.2023.
//

import Foundation

final class SPLocationViewViewModel {
    
    private var locations: [SPLocations] = []
    
    // Location response info
    // Will contain next url, if present
    
    private var cellViewModels: [String] = []
    
    init() {}
    
    public func fetchLocations() {
        SPService.shared.execute(.listLocationsRequest, expecting: String.self) { result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }
}
