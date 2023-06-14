//
//  SPEpisodeImageCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 14.06.2023.
//

import Foundation
import UIKit

class SPEpisodeImageCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPEpisodeImageCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        // To not overflow
       
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "EpisodesDefault")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubviews(imageView)
        setUpLayer()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setUpLayer() {
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
           imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
           imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
           imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
           imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])

    }
    
    public func configure(with viewModel: SPEpisodeImageCollectionViewCellViewModel) {
       
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
                    self?.imageView.image = UIImage(named: "CharacrersDefault")
                }
                break
            }
        }
    }
}
