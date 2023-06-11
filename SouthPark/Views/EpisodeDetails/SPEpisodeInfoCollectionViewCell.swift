//
//  SPEpisodeInfoCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 11.06.2023.
//

import UIKit

class SPEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPEpisodeInfoCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        setUpLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setUpLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    func configure(with viewModel: SPEpisodeInfoCollectionViewCellViewModel) {
        
    }
    
}
