//
//  SPEndpoint.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import Foundation


// use enum to model all endpoints with raw value type String (Endpoint.character.raw would be a String "character").

/// Represents unique API endpoint
@frozen enum SPEndpoint: String {
    //Endpoint to character info
    case characters
    //Endpoint to location info
    case locations
    //Endpoint to episode info
    case episodes
    //Endpoint to family info
    case families
}
