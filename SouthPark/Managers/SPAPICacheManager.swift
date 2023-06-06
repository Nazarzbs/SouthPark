//
//  SPAPICacheManager.swift
//  SouthPark
//
//  Created by Nazar on 06.06.2023.
//

import Foundation

import Foundation

///Manages in memory session scoped API caches
final class SPAPICacheManager {
    //API URL: Data
    
    private var cacheDictionary: [
        SPEndpoint: NSCache<NSString, NSData>
    ] = [:]
    
    init() {
        setUpCache()
    }
    
    //MARK: - Public
    
    public func cachedResponse(for endpoint: SPEndpoint, url: URL?) -> Data? {
        guard let targetCash = cacheDictionary[endpoint], let url = url  else { return nil }
        
        let key = url.absoluteString as NSString
        return targetCash.object(forKey: key ) as? Data
    }
    
    public func setCache(for endpoint: SPEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endpoint], let url = url  else { return }
        
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    //MARK: - Private
    
    private func setUpCache() {
        SPEndpoint.allCases.forEach({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        })
    }
}
