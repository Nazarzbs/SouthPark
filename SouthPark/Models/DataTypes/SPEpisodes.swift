//
//  SPEpisodes.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import Foundation

struct SPEpisodes: Codable {
    let id: Int
    let name: String
    let season: Int
    let episode: String
    let air_date: String
    let wiki_url: String
    let thumbnail_url: String
    let description: String
    let created_at: String
    let updated_at: String
    let characters: [String]
    let locations: [String]
}
