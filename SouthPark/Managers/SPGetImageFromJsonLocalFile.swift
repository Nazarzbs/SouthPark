//
//  SPGetImageFromJsonLocalFile.swift
//  SouthPark
//
//  Created by Nazar on 24.05.2023.
//

import Foundation
import UIKit

final class SPGetImageFromJsonLocalFile {
    
//    Here are a few reasons why use a shared instance:
//
//    Encapsulation: By using a shared instance, you encapsulate the initialization logic and the private methods of the class within a single instance. This helps ensure that the state and behavior of the class are consistent across different parts of your code.
//    Access to Common Resources: If the class needs to access shared resources, such as a database connection or a network manager, a shared instance allows you to maintain a single connection or manager instance, reducing overhead and potential conflicts.
//    Convenience: Having a shared instance provides a convenient way to access the functionality of the class from any part of your code without needing to create multiple instances or pass around references.
//    Consistency: When using a shared instance, you guarantee that all code in your application interacts with the same instance of the class, ensuring consistency in data and behavior.
    
    static let shared = SPGetImageFromJsonLocalFile()
    
    private func readLocalFile(forName name: String) -> Data? {
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
    
    private func parse(_ jsonData: Data) -> SPCharactersImage? {
        do {
                let decodedData = try JSONDecoder().decode(SPCharactersImage.self, from: jsonData)
            return decodedData
            } catch {
                print("error: \(error)")
            }
        return nil
    }
    
    private func getUnscaledImageURL(from imageUrls: [SPCharacterImage]?) -> String {
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
    
    public func getImageUrlString(with characterName: String) -> URL? {
        guard let jsonData = SPGetImageFromJsonLocalFile.shared.readLocalFile(forName: "CharactersImage") else { return nil }
        let characterImageUrls = SPGetImageFromJsonLocalFile.shared.parse(jsonData)
        let imageURL = characterImageUrls?.images.filter {
            $0.title == characterName
        }
        let unscaledCharacterImageURL = SPGetImageFromJsonLocalFile.shared.getUnscaledImageURL(from: imageURL)
        
        guard let imageURL = URL(string: unscaledCharacterImageURL) else { return nil }
        return imageURL
    }
}
