//
//  SPGetImageFromJsonLocalFile.swift
//  SouthPark
//
//  Created by Nazar on 24.05.2023.
//

import Foundation

final class SPGetImageFromJsonLocalFile {
    
    static let shared = SPGetImageFromJsonLocalFile()
    
    public func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    public func parse(_ jsonData: Data) -> SPCharactersImage? {
        do {
                let decodedData = try JSONDecoder().decode(SPCharactersImage.self, from: jsonData)
            return decodedData
            } catch {
                print("error: \(error)")
            }
        return nil
    }
    
    public func getUnscaledImageURL(from imageUrls: [SPCharacterImage]?) -> String {
        var unscaledImageURL = ""
        let patterToRemove = #"scale-to-width-down/\d+"#
        let regex = try! NSRegularExpression(pattern: patterToRemove, options: [])

            let modifiedURLs = imageUrls.map { urlString in
                if !urlString.isEmpty {
                    let range = NSRange(location: 0, length: urlString.first!.link.utf16.count)
                    return regex.stringByReplacingMatches(in: urlString.first!.link, options: [], range: range, withTemplate: "")
                }
                return unscaledImageURL
            }
            unscaledImageURL = modifiedURLs ?? ""
        return unscaledImageURL
    }
}
