//
//  SPLocationTableViewCell.swift
//  SouthPark
//
//  Created by Nazar on 18.06.2023.
//

import UIKit

final class SPLocationTableViewCell: UITableViewCell {
    static let cellIdentifier = "SPLocationTableViewCell"
    
    private var name: UILabel = {
        let label = UILabel()
        label.layer.zPosition = 3
        label.font = SPConstants.setFont(fontSize: UIDevice.isiPhone ? 24 : 48, isBold: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var image: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.zPosition = 1
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "EpisodesDefault")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
     }()
    
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        view.layer.zPosition = 2
        view.alpha = 0.7
        //view.layer.cornerRadius = 0
        //view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
       // view.backgroundColor = UIColor(named: "midBackgroundColor")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(name, image, blurView)
        contentView.layer.cornerRadius = 8
        addConstraints()
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

        private func addConstraints() {
            let bounds = UIScreen.main.bounds
            
            NSLayoutConstraint.activate([
                name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIDevice.isiPhone ? 4 : 70.0),
                name.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
                name.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
                
                image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIDevice.isiPhone ? 0.0 : 70.0),
                image.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
                image.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
                image.heightAnchor.constraint(equalToConstant: UIDevice.isiPhone ? 200 : bounds.height / 2.2),
                
                blurView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                blurView.heightAnchor.constraint(equalToConstant: 40),
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
                    self?.image.image = UIImage(named: "CharacrersDefault")
                }
                break
            }
        }
    }
}
