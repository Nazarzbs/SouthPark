//
//  Extension .swift
//  SouthPark
//
//  Created by Nazar on 14.05.2023.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
