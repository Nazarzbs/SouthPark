//
//  SPCharacterEpisodeCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 23.05.2023.
//

import UIKit

final class SPCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPCharacterEpisodeCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpConstraints() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: SPCharacterEpisodeCollectionViewCellViewModel) {
        
    }
}
