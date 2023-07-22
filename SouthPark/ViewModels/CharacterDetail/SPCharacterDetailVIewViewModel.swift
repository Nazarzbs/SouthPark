//
//  SPCharacterDetailVIewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 20.05.2023.
//

import Foundation
import UIKit

protocol SPCharacterDetailVIewViewModelDelegate: AnyObject {
    func didFetchFamilies()
}

final class SPCharacterDetailVIewViewModel {
    // To know which character are we showing the detail screen for
    private let character: SPCharacter
    private let imageUrl: URL
  
    private var familyUrl: String
    
    weak var delegate: SPCharacterDetailVIewViewModelDelegate?
    
    public var episodes: [String] {
        character.episodes
    }
    
    //To store specific cell view model we use Associated Value with enum cases. 
    enum SectionType {
        case photo(viewModel: SPCharacterPhotoCollectionViewCellViewModel)
        
        case information(viewModels: [SPCharacterInfoCollectionViewCellViewModel])
        
        case episodes(viewModels: [SPCharacterEpisodeCollectionViewCellViewModel])
        
        case relatives(viewModels: [SPCharacterRelativesCollectionViewCellViewModel])
    }
    
    public var family: SPFamilies? {
        didSet {
            setUpSections()
        }
    }
    
    public var sections: [SectionType] = []
    
    //MARK: - Init
    
    init(character: SPCharacter, imageUrl: URL) {
        self.character = character
        self.imageUrl = imageUrl
        self.familyUrl = character.family
        fetchFamily()
        setUpSections()
    }

    func setUpSections() {
        sections = [
            .photo(viewModel: .init(imageUrl: imageUrl)),
            .information(viewModels: [
                .init(type: .age, value: String(character.age ?? 0)),
                .init(type: .sex, value: character.sex ?? ""),
                .init(type: .relatives, value: String(character.relatives.count)),
                .init(type: .occupation, value: character.occupation ?? ""),
                .init(type: .grade, value: character.grade ?? ""),
                .init(type: .religion, value: character.religion ?? ""),
                .init(type: .family, value: family?.name ?? ""),
                .init(type: .episodes, value: String(character.episodes.count)),
                .init(type: .created_at, value: String(character.created_at)),
            ]),
            .episodes(viewModels: character.episodes.compactMap ({
                return SPCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
            })),
            .relatives(viewModels: character.relatives.compactMap({
                return SPCharacterRelativesCollectionViewCellViewModel(relation: $0.relation, characterUrlString: $0.url)
            }))
            
        ]
    }
    
    public var requestUrl: URL? {
        return URL(string: character.url)
    }
    
    public var title: String {
        character.name.uppercased()
    }
    
    
    //MARK: - Layouts
    
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)) , subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
       
        return section
    }
    
    public func createInformationSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2, bottom: 2, trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(UIDevice.isiPhone ? 130 : 160)) , subitems: UIDevice.isiPhone ? [item, item, item] : [item, item, item, item])
        let section = NSCollectionLayoutSection(group: group)
       
        return section
    }
    
    public func createEpisodesSectionLayout() -> NSCollectionLayoutSection {
    
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 5, bottom: 5, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.9 : 0.4), heightDimension: .estimated(UIDevice.isiPhone ? 200 : 300)) , subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        // Define header
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(episodes.isEmpty ? 0 : 100))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerSupplementary]
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    func createCharacterLayout() -> NSCollectionLayoutSection {
       
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(UIDevice.isiPhone ? 0.33 : 0.25), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 5, bottom: 10, trailing: 5)
        
        var subitems: [NSCollectionLayoutItem] = []
        if UIDevice.isiPhone {
            subitems = [item, item, item]
        } else {
            subitems = [item, item, item, item]
        }
       
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)) , subitems: subitems)
        let section = NSCollectionLayoutSection(group: group)
        
        // Define header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(character.relatives.isEmpty ? 0 : 100))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [headerSupplementary]
        return section
    }
    
    public func fetchFamily() {
        guard let url = URL(string: familyUrl), let request = SPRequest(url: url) else {
            return
        }
        
        SPService.shared.execute(request, expecting: SPFamiliesData.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.family = model.data
                    self?.delegate?.didFetchFamilies()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
