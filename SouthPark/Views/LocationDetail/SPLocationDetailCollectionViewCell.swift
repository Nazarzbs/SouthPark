//
//  SPLocationCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 21.06.2023.
//

import UIKit

class SPLocationDetailCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "SPLocationCollectionViewCell"
    
    private var name: UILabel = {
        let label = UILabel()
        label.layer.zPosition = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 30 : 60, isBold: true)
        
        return label
    }()
    
    private var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let detailBlurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        view.layer.zPosition = 2
        view.alpha = 0.9
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let detailViewColorView: UIView = {
        let view = UIView()
        view.alpha = 0.01
        view.layer.zPosition = 1
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(name, image)

        image.addSubviews(detailViewColorView, detailBlurView)
        setupGradientView(view: detailViewColorView)
        addConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            image.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            image.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            name.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            name.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            
            detailViewColorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            detailViewColorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            detailViewColorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            detailViewColorView.heightAnchor.constraint(equalToConstant: UIDevice.isiPhone ? 48 : 78),
            
            detailBlurView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            detailBlurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            detailBlurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            detailBlurView.heightAnchor.constraint(equalToConstant: UIDevice.isiPhone ? 48 : 78),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        name.text = nil
        image.image = nil
    }
    
    
    public func configure(with viewModel: SPLocationTableViewCellViewModel) {
        name.text = viewModel.name
        
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    self?.image.image = image
                }
            case .failure(let error):
                print(String(describing: error))
                DispatchQueue.main.async {
                    self?.image.image = UIImage(named: "CharactersDefault")
                }
                break
            }
        }
    }
    
    private func setupGradientView(view: UIView) {
        let gradientLayer = CAGradientLayer()
        var coverColors: [CGColor] = []
        
        let bottomColor: CGColor = UIColor.clear.cgColor
        let topColor: CGColor = UIColor.clear.withAlphaComponent(0.0).cgColor
        coverColors.append(topColor)
        coverColors.append(bottomColor)
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = coverColors
        gradientLayer.locations = [0.0, 0.70]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame.size = CGSize(width: contentView.frame.width, height: UIDevice.isiPhone ? 48 : 78)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}


