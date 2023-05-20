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
            guard let jsonData = readLocalFile(forName: "CharactersImage") else { return print("Json data is missing!")}
            let characterImageUrls = parse(jsonData)
            
            for character in characters {
                
                let characterImageUrl = characterImageUrls?.images.filter {
                    return $0.title == character.name
                }
                
                let unscaledCharacterImageURL = getUnscaledImageURL(from: characterImageUrl)
                
                let viewModel = SPCharacterCollectionViewCellViewModel(characterName: character.name, characterOccupation: character.occupation ?? "Not given", characterImageUrl: URL(string: unscaledCharacterImageURL))
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
    
    //MARK: Get characters image
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parse(_ jsonData: Data) -> SPCharactersImage? {
        do {
                let decodedData = try JSONDecoder().decode(SPCharactersImage.self, from: jsonData)
            print(decodedData.images.count)
            return decodedData
            } catch {
                print("error: \(error)")
            }
        return nil
    }
    
    func getUnscaledImageURL(from imageUrls: [SPCharacterImage]?) -> String {
        var unscaledImageURL = ""
        let patterToRemove = #"scale-to-width-down/\d+"#
        let regex = try! NSRegularExpression(pattern: patterToRemove, options: [])

            let modifiedURLs = imageUrls.map { urlString in
                let range = NSRange(location: 0, length: urlString.first!.link.utf16.count)
                return regex.stringByReplacingMatches(in: urlString.first!.link, options: [], range: range, withTemplate: "")
            }
            unscaledImageURL = modifiedURLs ?? ""
        return unscaledImageURL
    }
}
