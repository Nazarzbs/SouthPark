//
//  SPRequest.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import Foundation
//Native type to build out a request 

//single request
/// Object that  represents a single API call
final class SPRequest {
    /// API Constants
    private struct Constants {
        static let baseUrl = "https://spapi.dev/api"
    }
    /// Desired endpoint
    private let endpoint: SPEndpoint
    /// Path components for API, if any
    private let pathComponents: [String]
    /// Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// Constructed URL for the api request in string format
    
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            //name=value&name=value
            let argumentString = queryParameters.compactMap({
                //unwrap it
                
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        return string
    }
    
    //? because url component is fallible
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    //MARK: - Public
    
    ///  Construct request
    ///  - Parameters:
    ///  - endpoint: Target endpoint
    ///  - pathComponents:  Collection of Path components
    ///  - queryParameters:  Collection of query parameters
    //[String] = [] because thats optional
    init(endpoint: SPEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}


extension SPRequest {
    //Improves readability
    static let listCharactersRequests = SPRequest(endpoint: .characters)
}

