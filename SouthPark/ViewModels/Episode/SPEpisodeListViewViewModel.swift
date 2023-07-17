//
//  SPEpisodeListViewViewModel.swift
//  SouthPark
//
//  Created by Nazar on 08.06.2023.
//

import Foundation
import UIKit

// AnyObject (class bound) - because we want to capture it in the weak capacity
// Protocol to tell our collection view EXPLICITLY to reload
// Define a protocol that declares the methods or properties that the delegate object should implement
protocol SPEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    
    func didSelectEpisode(_ episode: SPEpisode)
}

// View model to handle character list view logic
final class SPEpisodeListViewViewModel: NSObject {
    
    // Weak because we don't want to have leak memory
    public weak var delegate: SPEpisodeListViewViewModelDelegate?
    private var isLoadingMoreEpisodes = false
    
    private var episodes: [SPEpisode] = [] {
        didSet {

            for episode in episodes {
                let viewModel = SPCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: "https://spapi.dev/api/episodes/" + "\(episode.id)"))
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [SPCharacterEpisodeCollectionViewCellViewModel] = []
    private var apiInfo: SPGetAllEpisodesResponse.Links? = nil
    
    ///  Fetch initial set of episodes (20)
    func fetchEpisodes() {
        SPService.shared.execute(.listEpisodesRequest, expecting: SPGetAllEpisodesResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let result = responseModel.data
                let info = responseModel.links
                self?.episodes = result
                //tell delegate that we just in loaded initial episode, on the main thread because it is gonna trigger the updates of the view
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalEpisodes(url: URL) {
        guard !isLoadingMoreEpisodes else { return }
        isLoadingMoreEpisodes = true
        guard let request = SPRequest(url: url) else {
            isLoadingMoreEpisodes = false
            return
        }
        
        SPService.shared.execute(request, expecting: SPGetAllEpisodesResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.data
                let info = responseModel.links
               
                strongSelf.apiInfo = info
                let originalCount = strongSelf.episodes.count
                let newCount = moreResults.count
                let total = originalCount+newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                strongSelf.episodes.append(contentsOf: moreResults)
                //tell delegate that we just in loaded initial characters, on the main thread because it is gonna trigger the updates of the view
                
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
                    strongSelf.isLoadingMoreEpisodes = false
                    
                }
            case .failure(let failure):
                self?.isLoadingMoreEpisodes = false
                print(String(describing: failure))
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - CollectionView

extension SPEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SPEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? SPEpisodeCollectionViewCell else { fatalError("Unsupported cell")}
       
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
        let width = (bounds.width-40)
       
        return CGSize(width: width, height: UIDevice.isiPhone ? width * 0.95 : width * 0.75)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        //Notify the characterViewController using delegate pattern(The delegate pattern in Swift allows one object (the delegating object) to communicate and pass information to another object (the delegate object) in a loosely coupled manner.)
        delegate?.didSelectEpisode(episode)
        
    }
}

// MARK: - ScrollView
extension SPEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //
        guard shouldShowLoadMoreIndicator, !isLoadingMoreEpisodes, !cellViewModels.isEmpty, let nextUrlString = apiInfo?.next, let url = URL(string: nextUrlString) else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            //Calculates the vertical offset of the scroll view, the total height of the content within the scroll view, and the fixed height of the scroll view itself.
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalEpisodes(url: url)
            }
            t.invalidate()
        }
    }
}


