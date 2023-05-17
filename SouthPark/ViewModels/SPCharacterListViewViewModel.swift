//
//  CharacterListViewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 14.05.2023.
//

import Foundation
import UIKit

protocol SPCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
}

final class SPCharacterListViewViewModel: NSObject {
    
    // Weak because we don't want to have leak memory
    public weak var delegate: SPCharacterListViewViewModelDelegate?
    
    private var characters: [SPCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = SPCharacterCollectionViewCellViewModel(characterName: character.name, characterOccupation: character.occupation ?? "Not given")
                cellViewModels.append(viewModel)
            }
        }
    }
    
    private var cellViewModels: [SPCharacterCollectionViewCellViewModel] = []
    
    func fetchCharacters() {
        SPService.shared.execute(.listCharactersRequests, expected: SPGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let result = responseModel.data
                self?.characters = result
                //tell delegate that we just in loaded initial characters, on the main thread because it is gonna trigger the updates of the view
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension SPCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? SPCharacterCollectionViewCell else { fatalError("Unsupported cell")}
        
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(width: width, height: width * 1.5)
    }
}
