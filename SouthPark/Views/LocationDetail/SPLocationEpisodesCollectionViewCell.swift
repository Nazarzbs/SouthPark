//
//  SPLocationEpisodesCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 22.06.2023.
//

import UIKit

class SPLocationEpisodesCollectionViewCell: UICollectionViewCell {
    
        static let cellIdentifier = "SPLocationEpisodesCollectionViewCell"
        
        var prepareForReuseImage = false
       
        private let seasonLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
          
            label.font = .systemFont(ofSize: 12, weight: .semibold)
            return label
        }()
        
        private let nameLabel: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 12, weight: .regular)
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
            contentView.addSubviews(seasonLabel, thumbnailImageView, nameLabel)
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
            NSLayoutConstraint.activate([
                
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
               
                nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                
                thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                thumbnailImageView.heightAnchor.constraint(equalToConstant: 100),
                thumbnailImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
                thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
                thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                
                seasonLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 4),
                seasonLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                seasonLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    
            ])
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            nameLabel.text = nil
            seasonLabel.text = nil
            thumbnailImageView.image = nil
            
        }
        
        //Called every single time when cell is dequeued and we don't want fetching data every single time, we will use flag (have we fetch data for that episode? and if we haven't we go fetch, if we already fetching we don't want redundantly fetch)
        public func configure(with viewModel: SPLocationEpisodesDetailCellViewModel) {
          
            viewModel.registerForData { [weak self] (data, imageData)  in
                self?.nameLabel.text = data.name
                self?.seasonLabel.text = "Episode: "+"S0\(data.season)E0\(data.episode)"
                guard let data = imageData else { return }
                self?.thumbnailImageView.image = UIImage(data: data)
            }
            viewModel.fetchEpisode()
        }
    }
