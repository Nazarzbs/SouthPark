//
//  SPCharacterEpisodeCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 23.05.2023.
//

import UIKit

final class SPCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPCharacterEpisodeCollectionViewCell"
    
    var prepareForReuseImage = false
   
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
      
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 14, weight: .ultraLight)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        // To not overflow
       
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "EpisodesDefault")
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.addSubviews(seasonLabel, thumbnailImageView, nameLabel, airDateLabel, descriptionLabel)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            thumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 300),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 150),
            thumbnailImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            seasonLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8),
            seasonLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        
            descriptionLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4),

            airDateLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
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
