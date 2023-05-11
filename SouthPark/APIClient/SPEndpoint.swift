//
//  SPEndpoint.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import Foundation


// use enum to model all endpoints with raw value type String (Endpoint.character.raw would be a String "character").

/// Represents unique API endpoint
@frozen enum RMEndpoint: String {
    //Endpoint to character info
    case character
    //Endpoint to location info
    case location
    //Endpoint to episode info
    case episode
    //Endpoint to family info
    case family
}
