//
//  SPCharacterInfoCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 23.05.2023.
//

import UIKit

final class SPCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPCharacterInfoCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 9
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpConstraints() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: SPCharacterInfoCollectionViewCellViewModel) {
        
    }
}
