//
//  SPEpisodeDescriptionCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 14.06.2023.
//

import UIKit

class SPEpisodeDescriptionCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPEpisodeDescriptionCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 20 : 36, isBold: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 18 : 24, isBold: false)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "midBackgroundForDetail")
        contentView.addSubviews(titleLabel, valueLabel)
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
        layer.borderWidth = 0.2
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: UIDevice.isiPhone ? -4 : -15),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4),
            valueLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: UIDevice.isiPhone ? 8 : 15),
        ])

    }
    
    func configure(with viewModel: SPEpisodeInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
}

