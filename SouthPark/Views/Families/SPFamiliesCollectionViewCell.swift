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
            label.font = .systemFont(ofSize: 20, weight: .medium)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        private let characterOccupationLabel: UILabel = {
            let label =  UILabel()
            label.textColor = .label
            label.numberOfLines = 0
            label.font = .systemFont(ofSize: 14, weight: .regular)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        //MARK: - Init
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.backgroundColor = .secondarySystemBackground
            //We add it to the content view because it takes care of safe aria for us, if we added it to the cell directly but its not conceptually correct
            //addSubview() from extraction
            contentView.addSubviews(imageView, nameLabel, characterOccupationLabel)
            addConstraints()
            setUpLayer()
        }
        
        required init?(coder: NSCoder) {
            fatalError("Unsupported")
        }
        
        private func setUpLayer() {
            contentView.layer.cornerRadius = 8
            contentView.layer.shadowColor = UIColor.label.cgColor
            contentView.layer.shadowOffset =  CGSize(width: -2, height: 2)
            contentView.layer.shadowOpacity = 0.4
        }
        
        private func addConstraints() {
            NSLayoutConstraint.activate([
                characterOccupationLabel.heightAnchor.constraint(equalToConstant: 40),
                nameLabel.heightAnchor.constraint(equalToConstant: 30),
                
                characterOccupationLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
                characterOccupationLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
                nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
                nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
                
                characterOccupationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
                nameLabel.bottomAnchor.constraint(equalTo: characterOccupationLabel.topAnchor),
                
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
            characterOccupationLabel.text = nil
        }
        
    public func configure(with viewModel: SPFamiliesCollectionViewCellViewModel) {
      
        viewModel.registerForData { [weak self] (data, imageData)  in
            self?.nameLabel.text = data.name
            self?.characterOccupationLabel.text = data.occupation
            if let data = imageData {
                self?.imageView.image = UIImage(data: data)
            } else {
                self?.imageView.image = UIImage(named: "CharacrersDefault")
            }
        }
        viewModel.fetchCharacter()
    }
}
