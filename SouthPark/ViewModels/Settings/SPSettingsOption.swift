//
//  SPSettingsOption.swift
//  SouthPark
//
//  Created by Nazar on 15.06.2023.
//

import Foundation
import UIKit

enum SPSettingsOption: CaseIterable {
    case rateApp
    case contact
    case terms
    case privacy
    case apiReference
    case viewCode
    
    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contact:
            return URL(string: "https://twitter.com/nazarzbs")
        case .terms:
            return URL(string: "https://twitter.com/nazarzbs")
        case .privacy:
            return URL(string: "https://twitter.com/nazarzbs")
        case .apiReference:
            return URL(string: "https://spapi.dev/docs#searching")
        case .viewCode:
            return URL(string: "https://github.com/Nazarzbs/SouthPark")
        }
    }
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contact:
            return "Contact Us"
        case .terms:
            return "Terms of Service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .viewCode:
            return "View App Code"
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contact:
            return .systemGreen
        case .terms:
            return .systemRed
        case .privacy:
            return .systemYellow
        case .apiReference:
            return .systemOrange
        case .viewCode:
            return .systemPink
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contact:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
}
