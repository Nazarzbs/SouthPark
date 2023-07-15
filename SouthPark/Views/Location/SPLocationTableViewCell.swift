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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "EpisodesDefault")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
     }()
    
    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(name, image)
        addConstraints()
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

        private func addConstraints() {
            NSLayoutConstraint.activate([
                name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                name.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
                name.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
                
                image.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10),
                image.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
                image.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
                image.heightAnchor.constraint(equalToConstant: 200)
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
