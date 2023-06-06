//
//  CharacterListViewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 14.05.2023.
//

import Foundation
import UIKit

// AnyObject (class bound) - because we want to capture it in the weak capacity
// Protocol to tell our collection view EXPLICITLY to reload
// Define a protocol that declares the methods or properties that the delegate object should implement
protocol SPCharacterListViewViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    
    func didSelectCharacter(_ character: SPCharacter)
}

// View model to handle character list view logic
final class SPCharacterListViewViewModel: NSObject {
    
    // Weak because we don't want to have leak memory
    public weak var delegate: SPCharacterListViewViewModelDelegate?
    private var isLoadingMoreCharacters = false
    
    private var characters: [SPCharacter] = [] {
        didSet {
            guard let jsonData = SPGetImageFromJsonLocalFile.shared.readLocalFile(forName: "CharactersImage") else { return print("Json data is missing!")}
            let characterImageUrls = SPGetImageFromJsonLocalFile.shared.parse(jsonData)

            for character in characters {
            
                let characterImageUrl = characterImageUrls?.images.filter {
                    return $0.title == character.name
                }
                
                let unscaledCharacterImageURL = SPGetImageFromJsonLocalFile.shared.getUnscaledImageURL(from: characterImageUrl)
                
                let viewModel = SPCharacterCollectionViewCellViewModel(characterName: character.name, characterOccupation: character.occupation ?? "Not given", characterImageUrl: URL(string: unscaledCharacterImageURL), id: character.id)
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [SPCharacterCollectionViewCellViewModel] = []
    private var apiInfo: SPGetAllCharactersResponse.Links? = nil
    
    ///  Fetch initial set of characters (20)
    func fetchCharacters() {
        SPService.shared.execute(.listCharactersRequests, expecting: SPGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let result = responseModel.data
                let info = responseModel.links
                self?.characters = result
                //tell delegate that we just in loaded initial characters, on the main thread because it is gonna trigger the updates of the view
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else { return }
        isLoadingMoreCharacters = true
        guard let request = SPRequest(url: url) else {
            isLoadingMoreCharacters = false
            return
        }
        
        SPService.shared.execute(request, expecting: SPGetAllCharactersResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.data
                let info = responseModel.links
               
                strongSelf.apiInfo = info
                let originalCount = strongSelf.characters.count
                let newCount = moreResults.count
                let total = originalCount+newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.characters.append(contentsOf: moreResults)
                //tell delegate that we just in loaded initial characters, on the main thread because it is gonna trigger the updates of the view
                
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                    strongSelf.isLoadingMoreCharacters = false
                    
                }
            case .failure(let failure):
                self?.isLoadingMoreCharacters = false
                print(String(describing: failure))
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - CollectionView

extension SPCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? SPCharacterCollectionViewCell else { fatalError("Unsupported cell")}
        
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else { fatalError("Unsupported")}
        guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SPFooterLoadingCollectionReusableView.identifier, for: indexPath) as? SPFooterLoadingCollectionReusableView else { fatalError("Unsupported") }
        footer.startAnimating()
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        //Hide the footer 
        guard shouldShowLoadMoreIndicator else { return .zero}
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        //Notify the characterViewController using delegate pattern(The delegate pattern in Swift allows one object (the delegating object) to communicate and pass information to another object (the delegate object) in a loosely coupled manner.)
        delegate?.didSelectCharacter(character)
        
    }
}

// MARK: - ScrollView
extension SPCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
        guard shouldShowLoadMoreIndicator, !isLoadingMoreCharacters, !cellViewModels.isEmpty, let nextUrlString = apiInfo?.next, let url = URL(string: nextUrlString) else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            //Calculates the vertical offset of the scroll view, the total height of the content within the scroll view, and the fixed height of the scroll view itself.
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate()
        }
    }
}


