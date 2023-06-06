//
//  SPEpisodeDetailViewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 06.06.2023.
//

import UIKit

class SPEpisodeDetailViewViewModel {
    private let endpointURL: URL?
    
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }
    
    private func fetchEpisodeData() {
        guard let url = endpointURL, let request = SPRequest(url: url) else { return }
        SPService.shared.execute(request, expecting: SPEpisodes.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure(let failure):
                break
            }
        }
    }
}
