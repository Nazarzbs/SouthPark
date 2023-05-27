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
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    public var title: String {
        self.type.displayTitle
    }
    
    public var displayValue: String {
        if value.isEmpty { return "None" }
       
        if let date = Self.dateFormatter.date(from: value), type == .created_at || type == .updated_at  {
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
        case updated_at
        
        var tintColor: UIColor {
            switch self {
            case .age:
                return .systemBlue
            case .sex:
                return .systemRed
            case .relatives:
                return .systemCyan
            case .occupation:
                return .systemMint
            case .grade:
                return .systemPink
            case .religion:
                return .systemBrown
            case .family:
                return .systemOrange
            case .episodes:
                return .systemYellow
            case .created_at:
                return .systemTeal
            case .updated_at:
                return .systemBrown
            }
        }
        
        var displayTitle: String {
            switch self {
            case .age, .sex, .relatives, .occupation, .grade, .religion, .family:
                return rawValue.uppercased()
            case .episodes:
                return "EPISODES COUNT"
            case .updated_at:
                return "UPDATED"
            case .created_at:
                return "CREATED"
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .age:
                return UIImage(systemName: "bell")
            case .sex:
                return UIImage(systemName: "bell")
            case .relatives:
                return UIImage(systemName: "bell")
            case .occupation:
                return UIImage(systemName: "bell")
            case .grade:
                return UIImage(systemName: "bell")
            case .religion:
                return UIImage(systemName: "bell")
            case .family:
                return UIImage(systemName: "bell")
            case .episodes:
                return UIImage(systemName: "bell")
            case .updated_at:
                return UIImage(systemName: "bell")
            case .created_at:
                return UIImage(systemName: "bell")
            }
        }
    }
 
    init(type: `Type`, value: String) {
        self.value = value
        self.type = type
    }
}
