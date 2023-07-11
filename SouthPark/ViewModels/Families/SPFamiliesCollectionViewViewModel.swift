//
//  SPFamiliesCollectionViewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 28.06.2023.
//

import Foundation
import UIKit

protocol SPFamiliesCollectionViewViewModelDelegate: AnyObject {
    func didLoadInitialFamilies()
    func didLoadMoreFamilies(with newSectionIndexSet: IndexSet, and newIndexPaths: [IndexPath])
    func didSelectFamiliesMember(_ character: SPCharacter)
}

final class SPFamiliesCollectionViewViewModel: NSObject {
    
    private var fetchInProgress: Set<IndexPath> = []
    private var footer: SPFooterLoadingCollectionReusableView?
    
    // Weak because we don't want to have leak memory
    public weak var delegate: SPFamiliesCollectionViewViewModelDelegate?
    private var isLoadingMoreFamilies = false
    private var families: [SPFamilies] = [] {
        didSet {
        }
    }
    
    private var apiInfo: SPGetAllFamiliesResponse.Links? = nil
    
    public func fetchFamilies() {
        SPService.shared.execute(.listFamiliesRequest, expecting: SPGetAllFamiliesResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let result = responseModel.data
                self?.families = result
                self?.apiInfo = responseModel.links
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialFamilies()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional families are needed
    public func fetchAdditionalFamilies(url: URL) {
        guard !isLoadingMoreFamilies else { return }
        isLoadingMoreFamilies = true
        guard let request = SPRequest(url: url) else {
            isLoadingMoreFamilies = false
            return
        }
        
        SPService.shared.execute(request, expecting: SPGetAllFamiliesResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                
                let moreResults = responseModel.data
                let info = responseModel.links
                
                strongSelf.apiInfo = info
                let originalCount = strongSelf.families.count
                let newCount = moreResults.count
                let total = (originalCount) + newCount
                let startingIndex = total - newCount
                
                // Create index set for new sections
                let newSectionIndexSet = IndexSet(integersIn: originalCount..<(originalCount + newCount))
                strongSelf.families.append(contentsOf: moreResults)
            
                // Create array of index paths for new items

                let indexPathsToAdd: [IndexPath] = (startingIndex..<(startingIndex+newCount)).flatMap { index in
                    (0..<strongSelf.families[index].characters.count).map { row in
                        IndexPath(row: row, section: index)
                    }
                }
                
                //tell delegate that we just in loaded initial families, on the main thread because it is gonna trigger the updates of the view
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreFamilies(with: newSectionIndexSet, and: indexPathsToAdd)
                    strongSelf.isLoadingMoreFamilies = false
                    
                }
            case .failure(let failure):
                self?.isLoadingMoreFamilies = false
                print(String(describing: failure))
            }
        }
    }
        public var shouldShowLoadMoreIndicator: Bool {
            return apiInfo?.next != nil
    }
}

// MARK: CollectionView

extension SPFamiliesCollectionViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //Collection View
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return families.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return families[section].characters.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPFamiliesCollectionViewCell.cellIdentifier, for: indexPath) as? SPFamiliesCollectionViewCell else { fatalError("Unsupported cell")}
       
        guard let characterURL = URL(string: families[indexPath.section].characters[indexPath.row]) else { fatalError() }
    
        guard let request = SPRequest(url: characterURL) else { return cell }
        
        if SPService.shared.cacheManager.cachedResponse(for: request.endpoint, url: request.url) != nil {
            // Remove the indexPath from fetchInProgress since fetch is completed
            self.fetchInProgress.remove(indexPath)
            // cell.configure(with: cachedData)
            cell.configure(with: SPFamiliesCollectionViewCellViewModel(characterDataUrl: characterURL))
                } else if !fetchInProgress.contains(indexPath) {
                        // Configure the cell
                    cell.configure(with: SPFamiliesCollectionViewCellViewModel(characterDataUrl: characterURL))
                    
                    // Add the indexPath to fetchInProgress to indicate that a fetch is in progress
                    fetchInProgress.insert(indexPath)
                }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let characterDataUrl = families[indexPath.section].characters[indexPath.row]
        //Notify the characterViewController using delegate pattern(The delegate pattern in Swift allows one object (the delegating object) to communicate and pass information to another object (the delegate object) in a loosely coupled manner.)
        
        guard let url = URL(string: characterDataUrl), let request = SPRequest(url: url) else { return }

        SPService.shared.execute(request, expecting: SPCharactersData.self) { result in
            switch result {
            case .success(let character):
                self.delegate?.didSelectFamiliesMember(character.data)
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    // MARK: - Supplementary view header/footer

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FamilyNameHeaderCollectionReusableView.identifier, for: indexPath) as! FamilyNameHeaderCollectionReusableView
            header.label.text = families[indexPath.section].name 
            return header
        } else if kind == UICollectionView.elementKindSectionFooter, indexPath.section == (families.count) - 1 {
            footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SPFooterLoadingCollectionReusableView.identifier, for: indexPath) as? SPFooterLoadingCollectionReusableView
            footer?.startAnimating()
            return footer!
        } else {
            let footerDefault = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FamilyNameFooterCollectionReusableView.identifier, for: indexPath) as! FamilyNameFooterCollectionReusableView
            
            return footerDefault
        }
    }
}

// MARK: - ScrollView
extension SPFamiliesCollectionViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
        guard shouldShowLoadMoreIndicator, !isLoadingMoreFamilies, let nextUrlString = apiInfo?.next, let url = URL(string: nextUrlString) else {
            footer?.hideSpinner()
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] t in
            self?.footer?.stopAnimating()
            //Calculates the vertical offset of the scroll view, the total height of the content within the scroll view, and the fixed height of the scroll view itself.
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalFamilies(url: url)
            }
            t.invalidate()
        }
    }
}

