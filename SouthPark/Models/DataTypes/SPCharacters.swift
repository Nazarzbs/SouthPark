//
//  SPCharacters.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import Foundation

struct SPCharactersData: Codable {
    let data: SPCharacter
}

struct SPCharacter: Codable, SPCharacterDataRender {
    let id: Int
    let name: String
    let age: Int?
//    let sex: SPCharacterGender?
    let sex: String?
    let hair_color: String?
    let occupation: String?
    let grade: String?
    let religion: String?
    let voiced_by: String?
    let created_at: String
    let updated_at: String
    let url: String
    let family: String
    let relatives: [SPRelatives]
    let episodes: [String]
}

