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
        contentView.backgroundColor = .systemBlue
        contentView.layer.cornerRadius = 8
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
        viewModel.registerForData { data in
            print(data.name)
            print(data.episode)
            print(data.season)
            print(data.air_date)
            print(data.thumbnail_url)
            print(data.description)
        }
        viewModel.fetchEpisode()
    }
}
