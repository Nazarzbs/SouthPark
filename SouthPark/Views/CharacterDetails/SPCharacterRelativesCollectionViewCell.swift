//
//  SPCharacterRelativesCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 20.07.2023.
//

import UIKit

class SPCharacterRelativesCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPCharacterRelativesCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //       imageView.backgroundColor = UIColor(named: "activeBackgroundColor")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label =  UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        label.font = SPConstants.setFont(fontSize: 18, isBold: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterRelatives: UILabel = {
        let label =  UILabel()
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = SPConstants.setFont(fontSize: 12, isBold: false)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Gradient
    private let detailBlurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        view.layer.zPosition = 3
        //view.layer.cornerRadius = 0
        //view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        // view.backgroundColor = UIColor(named: "midBackgroundColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let detailViewColorView: UIView = {
        let view = UIView()
        view.alpha = 0.37
        view.layer.zPosition = 2
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        //We add it to the content view because it takes care of safe aria for us, if we added it to the cell directly but its not conceptually correct
        //addSubview() from extraction
        contentView.addSubviews(imageView, nameLabel, characterRelatives)
        
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
        contentView.layer.shadowColor = UIColor.label.cgColor
        contentView.layer.shadowOffset =  CGSize(width: -1, height: 1)
        contentView.layer.shadowOpacity = 0.4
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            characterRelatives.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            characterRelatives.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            characterRelatives.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            
            characterRelatives.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            nameLabel.bottomAnchor.constraint(equalTo: characterRelatives.topAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -3),
            
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
        characterRelatives.text = nil
    }
    
    public func configure(with viewModel: SPCharacterRelativesCollectionViewCellViewModel) {
        viewModel.registerForData { [weak self] (data, imageData)  in
            self?.characterRelatives.text = "Relation: \(viewModel.relation)"
            self?.nameLabel.text = data.name
            guard let data = imageData else { return }
            self?.imageView.image = UIImage(data: data)
        }
        viewModel.fetchCharacters()
    }
}

extension SPCharacterRelativesCollectionViewCell {
    
    private func addConstraintsForBlurView() {
        NSLayoutConstraint.activate([
            
            detailViewColorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            detailViewColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            detailViewColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            detailViewColorView.heightAnchor.constraint(equalToConstant: 60),
            
            detailBlurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            detailBlurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            detailBlurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            detailBlurView.heightAnchor.constraint(equalToConstant: 60),
            
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
        gradientLayer.frame.size = CGSize(width: contentView.frame.width, height: 60)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
