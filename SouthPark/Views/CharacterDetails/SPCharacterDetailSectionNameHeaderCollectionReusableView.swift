//
//  SPCharacterDetailSectionNameHeaderCollectionReusableView.swift
//  SouthPark
//
//  Created by Nazar on 20.07.2023.
//

import UIKit

class SPCharacterDetailSectionNameHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "SPCharacterDetailSectionNameHeaderCollectionReusableView"
    
    let label: UILabel = {
        
        let label = UILabel()
        if UIDevice.isiPhone {
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        } else {
            label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        }
        label.text = "Default Text"
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -30),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        label.text = title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
    

