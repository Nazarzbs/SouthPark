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
        label.layer.zPosition = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 12 : 20, isBold: false)
        label.textColor = .label
        return label
    }()
    
    private let episodeLabel: UILabel = {
        let label = UILabel()
        label.layer.zPosition = 6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 12 : 20, isBold: false)
        label.textColor = .label
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.layer.zPosition = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.contentMode = .topLeft
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 18 : 36, isBold: true)
        label.textColor = .label
        
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.layer.zPosition = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 12 : 18, isBold: false)
        label.textColor = .label
        
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.zPosition = 1
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(named: "activeBackgroundColor")
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "EpisodesDefault")
        return imageView
    }()
    
    private let imageOuterView: UIView = {
        let view = UIView()
        view.layer.zPosition = 3
        
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: "midBackgroundColorAlfa1")
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let detailBlurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        view.layer.zPosition = 3
        view.alpha = 0.05
        //view.layer.cornerRadius = 0
        //view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//        view.backgroundColor = UIColor(named: "midBackgroundColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
        
        // MARK: - Init
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.layer.cornerRadius = 8
            contentView.addSubviews(seasonLabel, nameLabel, airDateLabel, imageOuterView, episodeLabel)
            imageOuterView.addSubview(thumbnailImageView)
            imageOuterView.addSubview(detailBlurView)
            addConstraints()
            setupGradientView(view: imageOuterView)
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            imageOuterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageOuterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            imageOuterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            imageOuterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            
            thumbnailImageView.leadingAnchor.constraint(equalTo: imageOuterView.leadingAnchor, constant: 70),
            thumbnailImageView.trailingAnchor.constraint(equalTo: imageOuterView.trailingAnchor, constant: 0),
            thumbnailImageView.bottomAnchor.constraint(equalTo: imageOuterView.bottomAnchor, constant: 0),
            thumbnailImageView.topAnchor.constraint(equalTo: imageOuterView.topAnchor, constant: 0),
            
            seasonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            seasonLabel.heightAnchor.constraint(equalToConstant: 30),
            
            episodeLabel.leadingAnchor.constraint(equalTo: seasonLabel.trailingAnchor, constant: 5),
            episodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            episodeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            episodeLabel.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: UIDevice.isiPhone ? 100 : 200),
            nameLabel.widthAnchor.constraint(equalToConstant: bounds.width / 2.2),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            airDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            airDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            airDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            airDateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            detailBlurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            detailBlurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            detailBlurView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            detailBlurView.widthAnchor.constraint(equalToConstant: bounds.width / 3),
            
        ])
    }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            nameLabel.text = nil
            seasonLabel.text = nil
            episodeLabel.text = nil
            airDateLabel.text = nil
            thumbnailImageView.image = nil
        }
        
        //Called every single time when cell is dequeued and we don't want fetching data every single time, we will use flag (have we fetch data for that episode? and if we haven't we go fetch, if we already fetching we don't want redundantly fetch)
        public func configure(with viewModel: SPCharacterEpisodeCollectionViewCellViewModel) {
          
            viewModel.registerForData { [weak self] (data, imageData)  in
                self?.nameLabel.text = data.name
                self?.seasonLabel.text = "Season \(data.season)"
                self?.episodeLabel.text = "Episode \(data.episode)"
                self?.airDateLabel.text = "Aired on: "+data.air_date
                guard let data = imageData else { return }
                self?.thumbnailImageView.image = UIImage(data: data)
            }
            viewModel.fetchEpisode()
        }
    
    private func setupGradientView(view: UIView) {
        let gradientLayer = CAGradientLayer()
        var coverColors: [CGColor] = []
        
        let leadingColor: CGColor = UIColor(named: "midBackgroundColorAlfa1")!.cgColor
        let trailingColor: CGColor = UIColor(named: "midBackgroundColorAlfa0.1")!.cgColor
       
        coverColors.append(leadingColor)
        coverColors.append(trailingColor)
        gradientLayer.frame = view.bounds
        gradientLayer.colors = coverColors
        gradientLayer.locations = [0.35, 0.80]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame.size = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        gradientLayer.zPosition = 2
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
