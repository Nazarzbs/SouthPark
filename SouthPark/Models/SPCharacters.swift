//
//  SPCharacters.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import Foundation

struct SPCharacter: Codable {
    let id: Int
    let name: String
    let age: Int
    let sex: SPCharacterGender
    let hair_color: String
    let occupation: String
    let grade: SPCharacterGender
    let religion: String
    let voiced_by: String
    let created_at: String
    let updated_at: String
    let url: String
    let family: String
    let relatives: [SPRelatives]
    let episodes: [String]
}


