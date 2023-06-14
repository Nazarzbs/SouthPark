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
    private let imageUrl: URL
    
    public var episodes: [String] {
        character.episodes
    }
    
    //To store specific cell view model we use Associated Value with enum cases. 
    enum SectionType {
        case photo(viewModel: SPCharacterPhotoCollectionViewCellViewModel)
        
        case information(viewModels: [SPCharacterInfoCollectionViewCellViewModel])
        
        case episodes(viewModels: [SPCharacterEpisodeCollectionViewCellViewModel])
    }
    
    public var sections: [SectionType] = []
    
    //MARK: - Init
    
    init(character: SPCharacter, imageUrl: URL) {
        self.character = character
        self.imageUrl = imageUrl
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
                .init(type: .family, value: character.family),
                .init(type: .episodes, value: String(character.episodes.count)),
                .init(type: .updated_at, value: character.updated_at),
                .init(type: .created_at, value: String(character.created_at)),
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 20, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(400)) , subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}
