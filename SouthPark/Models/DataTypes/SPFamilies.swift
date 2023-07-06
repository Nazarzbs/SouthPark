//
//  SPFamilies.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import Foundation

struct SPFamiliesData: Codable {
    let data: SPFamilies
}

struct SPFamilies: Codable, Hashable {
    let id: Int
    let name: String
    let created_at: String
    let updated_at: String
    let characters: [String]
}
