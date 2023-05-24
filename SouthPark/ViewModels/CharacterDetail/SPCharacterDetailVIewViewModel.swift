//
//  SPCharacterDetailVIewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 20.05.2023.
//

import Foundation
import UIKit

final class SPCharacterDetailVIewViewModel {
    // To know which character are we showing the detail screen for
    private let character: SPCharacter
    private let image: String
    
    //To store specific cell view model we use Associated Value with enum cases. 
    enum SectionType {
        case photo(viewModel: SPCharacterPhotoCollectionViewCellViewModel)
        
        case information(viewModels: [SPCharacterInfoCollectionViewCellViewModel])
        
        case episodes(viewModels: [SPCharacterEpisodeCollectionViewCellViewModel])
    }
    
    public var sections: [SectionType] = []
    
    //MARK: - Init
    
    init(character: SPCharacter, image: String) {
        self.character = character
        self.image = image
        setUpSections()
    }

    func setUpSections() {
        sections = [
            .photo(viewModel: .init(imageUrl: URL(string: image ?? "??" ))),
            .information(viewModels: [
                .init(value: "\(String(describing: character.age))", title: "Age"),
                .init(value: "\(String(describing: character.sex))", title: "Sex"),
                .init(value: String(character.relatives.count), title: "Relatives"),
                .init(value: "\(String(describing: character.occupation))", title: "Occupation"),
                .init(value: "\(String(describing: character.grade))", title: "Grade"),
                .init(value: "\(String(describing: character.religion))", title: "Religion"),
                .init(value: character.family, title: "Family"),
                .init(value: "\(character.episodes.count)", title: "Total Episodes"),
              
            ]),
            .episodes(viewModels: character.episodes.compactMap ({
                return SPCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0))
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
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150)) , subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
       
        return section
    }
    
    public func createEpisodesSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(150)) , subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}
