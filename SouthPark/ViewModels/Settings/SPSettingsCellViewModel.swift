//
//  SPSettingsCellViewModel.swift
//  SouthPark
//
//  Created by Nazar on 15.06.2023.
//

import Foundation
import UIKit

//For loop over collection of that collection we use Identifiable to give each instances unique id

struct SPSettingsCellViewModel: Identifiable {
    let id = UUID()
    
    public let type: SPSettingsOption
    public let onTapHandler: (SPSettingsOption) -> Void
    
    //MARK: - init
    
    init(type: SPSettingsOption, onTapHandler: @escaping (SPSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    //MARK: - Public
    
    public var image: UIImage? {
        return type.iconImage
    }
    public var title: String {
        return type.displayTitle
    }
    
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
    }
}

