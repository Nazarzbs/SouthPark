//
//  SPEpisodeWikiCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 17.06.2023.
//

import UIKit

class SPEpisodeWikiCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPEpisodeWikiCollectionViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.zPosition = 2
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.layer.zPosition = 2
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.textColor = .link
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "EpisodeWikiColor")
        contentView.addSubviews(iconImageView, valueLabel)
       
        setUpLayer()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        valueLabel.text = nil
    }
    
    private func setUpLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            valueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            valueLabel.rightAnchor.constraint(lessThanOrEqualTo: iconImageView.leftAnchor, constant: 4),
            
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            iconImageView.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: -10),
            
            iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])

    }
    
    func configure(with viewModel: SPEpisodeInfoCollectionViewCellViewModel) {
        let config = UIImage.SymbolConfiguration(hierarchicalColor: .systemBlue)
        let image = UIImage(systemName: "arrowshape.turn.up.forward.circle.fill", withConfiguration: config)
        iconImageView.image = image
        valueLabel.text = viewModel.value
    }
}
