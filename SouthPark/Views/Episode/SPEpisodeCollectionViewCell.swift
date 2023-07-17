//
//  SPEpisodeCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 25.06.2023.
//

import UIKit

class SPEpisodeCollectionViewCell: UICollectionViewCell {
    
        static let cellIdentifier = "SPEpisodeCollectionViewCell"
        
        var prepareForReuseImage = false
       
        private let seasonLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
    
            if UIDevice.isiPhone {
                label.font = .systemFont(ofSize: 18, weight: .semibold)
            } else {
                label.font = .systemFont(ofSize: 40, weight: .semibold)
            }
           
            return label
        }()
        
        private let nameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.textAlignment = .center
            if UIDevice.isiPhone {
                label.font = .systemFont(ofSize: 20, weight: .semibold)
            } else {
                label.font = .systemFont(ofSize: 40, weight: .semibold)
            }
            
            return label
        }()
        
        private let airDateLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            if UIDevice.isiPhone {
                label.font = .systemFont(ofSize: 14, weight: .semibold)
            } else {
                label.font = .systemFont(ofSize: 19, weight: .semibold)
            }
           
            return label
        }()
        
        private let descriptionLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
           
            label.font = .systemFont(ofSize: UIDevice.isiPhone ? 16 : 22, weight: .regular)
            label.adjustsFontSizeToFitWidth = true
            return label
        }()
        
        private let thumbnailImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            // To not overflow
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: "EpisodesDefault")
            return imageView
        }()
        
        // MARK: - Init
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUpLayer()
            contentView.backgroundColor = .secondarySystemBackground
            contentView.addSubviews(seasonLabel, thumbnailImageView, nameLabel, airDateLabel, descriptionLabel)
            setUpConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        private func setUpLayer() {
            contentView.layer.cornerRadius = 8
            contentView.layer.shadowColor = UIColor.label.cgColor
            contentView.layer.shadowOpacity = 0.4
            contentView.layer.shadowOffset =  CGSize(width: -2, height: 2)
        }
        
    private func setUpConstraints() {
        var imageHeight: CGFloat = 0
        var descriptionLabelLeadingAndTrailingAnchor = 8.0
        if UIDevice.isiPhone {
            imageHeight = 180
            descriptionLabelLeadingAndTrailingAnchor = 8
        } else {
            imageHeight = 500
            descriptionLabelLeadingAndTrailingAnchor = 40
        }
       
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
           
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: imageHeight),
          
            thumbnailImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
           

            descriptionLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: descriptionLabelLeadingAndTrailingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: -descriptionLabelLeadingAndTrailingAnchor),
           
            descriptionLabel.topAnchor.constraint(lessThanOrEqualTo: thumbnailImageView.bottomAnchor, constant: 15),
            descriptionLabel.bottomAnchor.constraint(equalTo: seasonLabel.topAnchor, constant: 8),
           
            
            seasonLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            seasonLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        
            airDateLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 6),
            airDateLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            nameLabel.text = nil
            seasonLabel.text = nil
            airDateLabel.text = nil
            descriptionLabel.text = nil
            thumbnailImageView.image = nil
            
        }
        
        //Called every single time when cell is dequeued and we don't want fetching data every single time, we will use flag (have we fetch data for that episode? and if we haven't we go fetch, if we already fetching we don't want redundantly fetch)
        public func configure(with viewModel: SPCharacterEpisodeCollectionViewCellViewModel) {
          
            viewModel.registerForData { [weak self] (data, imageData)  in
                self?.nameLabel.text = data.name
                self?.seasonLabel.text = "Episode: "+"S0\(data.season)E0\(data.episode)"
                self?.airDateLabel.text = "Aired on: "+data.air_date
                self?.descriptionLabel.text = data.description
                guard let data = imageData else { return }
                self?.thumbnailImageView.image = UIImage(data: data)
            }
            viewModel.fetchEpisode()
        }
}
