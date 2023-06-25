//
//  SPLocationCollectionViewCell.swift
//  SouthPark
//
//  Created by Nazar on 21.06.2023.
//

import UIKit

class SPLocationCollectionViewCell: UICollectionViewCell {
        static let cellIdentifier = "SPLocationCollectionViewCell"
        
        private var name: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 20, weight: .medium)
            return label
        }()
        
        private var image: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
         }()
        
        //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(name, image)
        addConstraints()
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
                    image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
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
    }


