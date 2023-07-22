//
//  SPCharacterInfoCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 23.05.2023.
//
import UIKit

final class SPCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPCharacterInfoCollectionViewCell"
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 18 : 20, isBold: true)
        label.textColor = SPConstants.basicTextColor
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 11 : 15, isBold: false)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "midBackgroundForDetail")
        contentView.layer.cornerRadius = 8
        contentView.addSubviews(valueLabel, titleLabel, iconImageView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30),
            
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            valueLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        valueLabel.text = nil
        titleLabel.text = nil
        iconImageView.image = nil
    }
    
    public func configure(with viewModel: SPCharacterInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.displayValue
        valueLabel.textColor = viewModel.tintColor
        iconImageView.image = viewModel.iconImage
        iconImageView.tintColor = viewModel.tintColor
    }
}
