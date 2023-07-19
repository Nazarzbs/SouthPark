
//  SPConstants.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import UIKit

/// The constants used everywhere in the app like UIColors, Font sizes, etc
struct SPConstants {
    
    static let mainColor: UIColor = UIColor(red: 170/255, green: 255/255, blue: 100/255, alpha: 1.0)
    
    //MARK: View colors
    
    ///The darkBackgroundColor is the UIColor for simple background areas. It's the darkest background color
    static let darkBackgroundColor: UIColor = UIColor(red: 18/255, green: 18/255, blue: 22/255, alpha: 1.0)
    
    ///The midBackgroundColor is the UIColor for differentiated, slightly lighter backgrounds. Example for the tab view controller.
    static let midBackgroundColor: UIColor = UIColor(red: 24/255, green: 24/255, blue: 28/255, alpha: 1.0)
    
    ///The activeBackgroundColor is the UIColor for active or highlighted, backgrounds. It's the same color as the keyboard
    static let activeBackgroundColor: UIColor = UIColor(red: 42/255, green: 42/255, blue: 47/255, alpha: 1.0)
    
    
    //MARK: Text colors
    
    ///The activeBackgroundColor is the UIColor for active or highlighted, backgrounds. It's the same color as the keyboard
    static let highlightedTextColor: UIColor = UIColor(red: 251/255, green: 252/255, blue: 254/255, alpha: 1.0)
    
    ///The activeBackgroundColor is the UIColor for active or highlighted, backgrounds. It's the same color as the keyboard
    static let basicTextColor: UIColor = UIColor(red: 212/255, green: 212/255, blue: 216/255, alpha: 1.0)
    
    ///The activeBackgroundColor is the UIColor for active or highlighted, backgrounds. It's the same color as the keyboard
    static let secondaryTextColor: UIColor = UIColor(red: 162/255, green: 162/255, blue: 166/255, alpha: 1.0)
    
    ///The activeBackgroundColor is the UIColor for active or highlighted, backgrounds. It's the same color as the keyboard
    static let inactiveTextColor: UIColor = UIColor(red: 90/255, green: 90/255, blue: 94/255, alpha: 1.0)
    
    
    //MARK: Font
    public static func setFont(fontSize: CGFloat, isBold: Bool) -> UIFont {
        if isBold {
            return UIFont(name: "Avenir Next Demi Bold", size: fontSize)!
        } else {
            return UIFont(name: "Avenir Next Regular", size: fontSize)!
        }
    }
    
}
