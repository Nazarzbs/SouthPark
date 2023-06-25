//
//  SPLocations.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import Foundation

struct SPLocationsData: Codable {
    let data: SPLocation
}

struct SPLocation: Codable {
    let id: Int
    let name: String
    let created_at: String
    let updated_at: String
    let episodes: [String]
}
