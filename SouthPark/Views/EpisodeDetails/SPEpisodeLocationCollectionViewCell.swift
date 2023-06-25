//
//  SPEpisodeLocationCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 25.06.2023.
//

import UIKit

class SPEpisodeLocationCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPEpisodeLocationCollectionViewCell"
    
   private let imageView: UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFit
       imageView.translatesAutoresizingMaskIntoConstraints = false
       imageView.layer.cornerRadius = 8
       return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label =  UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        //We add it to the content view because it takes care of safe aria for us, if we added it to the cell directly but its not conceptually correct
        //addSubview() from extraction
        contentView.addSubviews(imageView, nameLabel)
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
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 160),
           
            nameLabel.topAnchor.constraint(lessThanOrEqualTo: imageView.bottomAnchor, constant: 4),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 7),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -7),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
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
    
    public func configure(with viewModel: SPEpisodeLocationsDetailCellViewModel) {
        nameLabel.text = viewModel.locationName
        
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(named: "picture")
                }
                break
            }
        }
    }
}
