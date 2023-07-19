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
       imageView.contentMode = .scaleAspectFill
       imageView.layer.cornerRadius = 12
       imageView.clipsToBounds = true
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label =  UILabel()
        label.layer.zPosition = 2
        
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageOuterView: UIView = {
        let view = UIView()
        view.layer.zPosition = 1
        
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: "midBackgroundColorAlfa1")
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    

    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//
        //We add it to the content view because it takes care of safe aria for us, if we added it to the cell directly but its not conceptually correct
        //addSubview() from extraction
        imageOuterView.addSubview(imageView)
        contentView.addSubviews(imageOuterView, nameLabel)
        setupGradientView(view: imageOuterView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
           
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 4),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -4),
            
            imageOuterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            imageOuterView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            imageOuterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            imageOuterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
        ])
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
    
    private func setupGradientView(view: UIView) {
        let gradientLayer = CAGradientLayer()
        var coverColors: [CGColor] = []
        
        let leadingColor: CGColor = UIColor(named: "midBackgroundColorAlfa1")!.cgColor
        let trailingColor: CGColor = UIColor(named: "midBackgroundColorAlfa0.1")!.cgColor
       
        coverColors.append(leadingColor)
        coverColors.append(trailingColor)
        gradientLayer.frame = view.bounds
        gradientLayer.colors = coverColors
        gradientLayer.locations = [0.1, 0.60]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        gradientLayer.frame.size = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        gradientLayer.zPosition = 2
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
