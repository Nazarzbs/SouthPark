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
    
    enum SPServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send South Park API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data  or error
    public func execute<T: Codable>(_ request: SPRequest, expected type: T.Type, completion: @escaping(Result<T, Error>) -> Void) {
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(SPServiceError.failedToCreateRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            data, _, error in
            guard let data = data, error == nil else { completion(.failure(error ?? SPServiceError.failedToGetData))
                return
            }
            
            // Decode responce
            
            do {
                //Instead of decoding/serialisation to the json, we will decode to the our type
//                let json = try JSONSerialization.jsonObject(with: data)
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    //MARK: - Private
    
    private func request(from spRequest: SPRequest) -> URLRequest? {
        guard let url = spRequest.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = spRequest.httpMethod
        
        return request
    }
}
