//
//  SPFooterLoadingCollectionReusableView.swift
//  SouthPark
//
//  Created by Nazar on 20.05.2023.
//

import UIKit

final class SPFooterLoadingCollectionReusableView: UICollectionReusableView {
        static let identifier = "SPFooterLoadingCollectionReusableView"
    
    // anonymous closure
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews(spinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    public func startAnimating() {
        spinner.startAnimating()
    }
    
    public func stopAnimating() {
        spinner.stopAnimating()
    }
    
    public func hideSpinner() {
        spinner.isHidden = true
        spinner.stopAnimating()
    }
}
