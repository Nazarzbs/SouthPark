//
//  SPService.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import Foundation
//Responsible for Api call


/// Primary Api service object to get South Park data
final class SPService {
    //Build it as a singleton initially(that aloud us to access from anywhere that is easier   and than with dependency injection when we clean up all code in the end
    
    /// Shared singleton instance
    static let shared = SPService()
    
    //to force to use our shared instance
    
    ///Privatised constructor
    private init() { }
    
    
    
    /// Send South Park API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback with data  or error
    public func execute(_ request: SPRequest, completion: @escaping() -> Void) {
        
    }
}
