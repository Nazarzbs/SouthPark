//
//  SPGetAllLocationsResponse.swift
//  SouthPark
//
//  Created by Nazar on 18.06.2023.
//

import Foundation

struct SPGetAllLocationsResponse: Codable {
    
    struct Links: Codable {
        let first: String
        let last: String
        let prev: String?
        let next: String?
    }
    
    struct Meta: Codable {
        let current_page: Int
        let from: Int
        let last_page: Int
//        let links: [String: String]
        let path: String
        let per_page: Int
        let to: Int
        let total: Int
    }

    let meta: Meta
    let links: Links
    let data: [SPLocation]
}
