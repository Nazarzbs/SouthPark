//
//  SPEpisodeInfoCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 11.06.2023.
//

import UIKit

class SPEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPEpisodeInfoCollectionViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 18 : 24, isBold: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 18 : 24, isBold: false)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "midBackgroundForDetail")
        contentView.addSubviews(titleLabel, valueLabel, iconImageView)
       
        setUpLayer()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
    }
    
    private func setUpLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 24),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: UIDevice.isiPhone ? 0.47 : 0.6),
            
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: UIDevice.isiPhone ? 40 : 55),
        ])

    }
    
    func configure(with viewModel: SPEpisodeInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
        iconImageView.image = viewModel.iconImageView
    }
    
}
