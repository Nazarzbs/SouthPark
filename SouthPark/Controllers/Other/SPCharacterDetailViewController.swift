//
//  SPCharacterDetailViewController.swift
//  SouthPark
//
//  Created by Nazar on 20.05.2023.
//

import UIKit

/// Controller to show info about single character
final class SPCharacterDetailViewController: UIViewController {
    
    private let viewModel: SPCharacterDetailVIewViewModel
    
    private let detailView: SPCharacterDetailVIew
    
    // MARK: - Init
    
    init(viewModel: SPCharacterDetailVIewViewModel ) {
        self.viewModel = viewModel
        self.detailView = SPCharacterDetailVIew(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        addConstraints()
        
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
    }
    
    @objc func didTapShare() {
        // Share character info
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - CollectionView

extension SPCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo(_):
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        case .relatives(viewModels: let viewModels):
            return viewModels.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPCharacterPhotoCollectionViewCell.cellIdentifier, for: indexPath) as? SPCharacterPhotoCollectionViewCell else { fatalError() }
            cell.configure(with: viewModel)
            return cell
        case .information(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPCharacterInfoCollectionViewCell.cellIdentifier, for: indexPath) as? SPCharacterInfoCollectionViewCell else {  fatalError() }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .episodes(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? SPEpisodeCollectionViewCell else { fatalError()}
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
    
            return cell
        case .relatives(viewModels: let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPCharacterRelativesCollectionViewCell.cellIdentifier, for: indexPath) as? SPCharacterRelativesCollectionViewCell else { fatalError()}
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo, .information:
          break
        case .episodes:
            let episodes = self.viewModel.episodes
            let selection = episodes[indexPath.row]
            let vc = SPEpisodeDetailViewController(url: URL(string: selection))
            navigationController?.pushViewController(vc, animated: true)
        case .relatives(viewModels: let viewModels):
            break
        }
    }
    
    // MARK: - Supplementary view header

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SPCharacterDetailSectionNameHeaderCollectionReusableView.identifier, for: indexPath) as! SPCharacterDetailSectionNameHeaderCollectionReusableView
        if indexPath.section == 2 {
            header.label.text = "Episodes"
        } else {
            header.label.text = "Relatives"
        }
            return header
    }
}
