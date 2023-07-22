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
        label.layer.zPosition = 5
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = SPConstants.setFont(fontSize: 20, isBold: false)
        label.textColor = .label
        return label
    }()
    
//    private let episodeLabel: UILabel = {
//        let label = UILabel()
//        label.layer.zPosition = 6
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .left
//        label.font = SPConstants.setFont(fontSize: 10, isBold: false)
//        label.textColor = .label
//        return label
//    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.layer.zPosition = 8
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.contentMode = .topLeft
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 11 : 26, isBold: true)
        label.textColor = .label
        
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.layer.zPosition = 8
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = SPConstants.setFont(fontSize: 15, isBold: false)
        label.textColor = .label
        
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.zPosition = 1
//        imageView.layer.cornerRadius = 12
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
        
        // MARK: - Init
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.layer.cornerRadius = 12
            contentView.addSubviews(seasonLabel, nameLabel, airDateLabel, imageOuterView)
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
            thumbnailImageView.trailingAnchor.constraint(equalTo: imageOuterView.trailingAnchor, constant: 8),
            thumbnailImageView.bottomAnchor.constraint(equalTo: imageOuterView.bottomAnchor, constant: 0),
            thumbnailImageView.topAnchor.constraint(equalTo: imageOuterView.topAnchor, constant: 0),
            
            seasonLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            seasonLabel.widthAnchor.constraint(equalToConstant: UIDevice.isiPhone ? 60 : 100),
            seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 100),
            nameLabel.widthAnchor.constraint(equalToConstant: bounds.width / 2),
            
            airDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            airDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            airDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
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
//            episodeLabel.text = nil
            airDateLabel.text = nil
            thumbnailImageView.image = nil
        }
        
        //Called every single time when cell is dequeued and we don't want fetching data every single time, we will use flag (have we fetch data for that episode? and if we haven't we go fetch, if we already fetching we don't want redundantly fetch)
        public func configure(with viewModel: SPCharacterEpisodeCollectionViewCellViewModel) {
          
            viewModel.registerForData { [weak self] (data, imageData)  in
                self?.nameLabel.text = data.name
                self?.seasonLabel.text = "S\(data.season) • E\(data.episode)"
//                self?.episodeLabel.text = "Episode \(data.episode)"
                self?.airDateLabel.text = "Aired on:\n"+data.air_date
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
        gradientLayer.locations = [0.2, 0.40]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 2, y: 0)
        gradientLayer.frame.size = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        gradientLayer.zPosition = 2
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
