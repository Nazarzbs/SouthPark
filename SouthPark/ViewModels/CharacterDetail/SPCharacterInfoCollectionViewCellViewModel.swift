//
//  SPCharacterInfoCollectionViewCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 23.05.2023.
//

import Foundation
import UIKit

final class SPCharacterInfoCollectionViewCellViewModel {
    private let type: `Type`
    
    public let value: String
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.timeZone = .current
        return formatter
    }()
    
    public var title: String {
        self.type.displayTitle
    }
    
    public var displayValue: String {
        if value.isEmpty { return "None" }
       
        if let date = Self.dateFormatter.date(from: value), type == .created_at  {
            return Self.shortDateFormatter.string(from: date)
        }
        return value
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    enum `Type`: String {
        case age
        case sex
        case relatives
        case occupation
        case grade
        case religion
        case family
        case episodes
        case created_at
//        case updated_at
        
        var tintColor: UIColor {
            switch self {
            case .age:
                return .systemRed
            case .sex:
                return .systemGreen
            case .relatives:
                return .systemYellow
            case .occupation:
                return .systemMint
            case .grade:
                return .systemPink
            case .religion:
                return .systemBrown
            case .family:
                return .systemOrange
            case .episodes:
                return .systemBlue
            case .created_at:
                return .systemPurple
            }
        }
        
        var displayTitle: String {
            switch self {
            case .age, .sex, .relatives, .occupation, .grade, .religion, .family:
                return rawValue.uppercased()
            case .episodes:
                return "EPISODES COUNT"
            case .created_at:
                return "CREATED"
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .age:
                let config = UIImage.SymbolConfiguration(hierarchicalColor: .systemRed)
                let image = UIImage(systemName: "cross.circle.fill", withConfiguration: config)
                return image
            case .sex:
                let config = UIImage.SymbolConfiguration(hierarchicalColor: .systemGreen)
                let image = UIImage(systemName: "person.fill.viewfinder", withConfiguration: config)
                return image
            case .relatives:
                let config = UIImage.SymbolConfiguration(hierarchicalColor: .systemYellow)
                let image = UIImage(systemName: "tree.circle.fill", withConfiguration: config)
                return image
            case .occupation:
                let config = UIImage.SymbolConfiguration(hierarchicalColor: .systemMint)
                let image = UIImage(systemName: "person.crop.square.filled.and.at.rectangle", withConfiguration: config)
                return image
            case .grade:
                let config = UIImage.SymbolConfiguration(hierarchicalColor: .systemPink)
                let image = UIImage(systemName: "graduationcap.circle", withConfiguration: config)
                return image
            case .religion:
                let config = UIImage.SymbolConfiguration(hierarchicalColor: .systemBrown)
                let image = UIImage(systemName: "mountain.2.fill", withConfiguration: config)
                return image
            case .family:
                return UIImage(systemName: "figure.2.and.child.holdinghands")
            case .episodes:
                let config = UIImage.SymbolConfiguration(hierarchicalColor: .systemBlue)
                let image = UIImage(systemName: "sparkles.tv", withConfiguration: config)
                return image
            case .created_at:
                let config = UIImage.SymbolConfiguration(hierarchicalColor: .systemPurple)
                let image = UIImage(systemName: "clock.circle.fill", withConfiguration: config)
                return image
            }
        }
    }
 
    init(type: `Type`, value: String) {
        self.value = value
        self.type = type
    }
}
