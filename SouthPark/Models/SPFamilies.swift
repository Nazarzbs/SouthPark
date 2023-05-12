//
//  SPFamilies.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import Foundation

struct SPFamilies: Codable {
    let id: String
    let name: String
    let created_at: String
    let updated_at: String
    let characters: [String]
}
