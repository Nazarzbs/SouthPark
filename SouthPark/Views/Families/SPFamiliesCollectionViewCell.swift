//
//  SPFamiliesCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 02.07.2023.
//

import UIKit

class SPFamiliesCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPFamiliesCollectionViewCell"
        
       private let imageView: UIImageView = {
           let imageView = UIImageView()
          
           imageView.contentMode = .scaleAspectFit
           imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
        }()
        
        private let nameLabel: UILabel = {
            let label =  UILabel()
            label.textColor = .label
            label.adjustsFontSizeToFitWidth = true
            label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 17 : 40, isBold: true)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
    //MARK: - Gradient
     private let detailBlurView: UIVisualEffectView = {
         let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
         view.layer.zPosition = 3
         view.alpha = 0.7
         view.layer.cornerRadius = 12
         view.backgroundColor = UIColor(named: "midBackgroundColor")
         view.translatesAutoresizingMaskIntoConstraints = false
         view.clipsToBounds = true
         return view
     }()
     
     private let detailViewColorView: UIView = {
         let view = UIView()
         view.alpha = 0.1
         view.layer.zPosition = 2
         view.layer.cornerRadius = 12
         view.translatesAutoresizingMaskIntoConstraints = false
         view.clipsToBounds = true
         return view
     }()
     
        
        //MARK: - Init
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = .secondarySystemBackground
            //We add it to the content view because it takes care of safe aria for us, if we added it to the cell directly but its not conceptually correct
            contentView.addSubviews(imageView, nameLabel)
            addConstraints()
            imageView.addSubviews(detailViewColorView, detailBlurView)
            addConstraintsForBlurView()
            setUpLayer()
            setupGradientView(view: detailViewColorView)
        }
        
        required init?(coder: NSCoder) {
            fatalError("Unsupported")
        }
        
        private func setUpLayer() {
            contentView.layer.cornerRadius = 8
        }
        
        private func addConstraints() {
            NSLayoutConstraint.activate([
                
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
                
                nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
                nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
                nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 8),
                
            ])
        }
        
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
            setUpLayer()
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            imageView.image = nil
            nameLabel.text = nil
        }
        
    public func configure(with viewModel: SPFamiliesCollectionViewCellViewModel) {
      
        viewModel.registerForData { [weak self] (data, imageData)  in
            self?.nameLabel.text = data.name
            if let data = imageData {
                self?.imageView.image = UIImage(data: data)
            } else {
                self?.imageView.image = UIImage(named: "CharacrersDefault")
            }
        }
        viewModel.fetchCharacter()
    }
}

extension SPFamiliesCollectionViewCell {
   
    private func addConstraintsForBlurView() {
        NSLayoutConstraint.activate([
    
            detailViewColorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            detailViewColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            detailViewColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            detailViewColorView.heightAnchor.constraint(equalToConstant: 50),

            detailBlurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            detailBlurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            detailBlurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            detailBlurView.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    
    private func setupGradientView(view: UIView) {
        let gradientLayer = CAGradientLayer()
        var coverColors: [CGColor] = []
        
        let bottomColor: CGColor = UIColor(named: "mainColor")!.cgColor
       
        let topColor: CGColor = UIColor.clear.withAlphaComponent(0.0).cgColor
        coverColors.append(topColor)
        coverColors.append(bottomColor)
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = coverColors
        gradientLayer.locations = [0.3, 0.70]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame.size = CGSize(width: contentView.frame.width, height: 50)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

