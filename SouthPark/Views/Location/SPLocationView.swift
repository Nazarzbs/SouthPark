//
//  SPLocationView.swift
//  SouthPark
//
//  Created by Nazar on 18.06.2023.
//

import UIKit

/// Interface to relay location view events

protocol SPLocationViewDelegate: AnyObject {
    func spLocationView(_ locationView: SPLocationView, didSelect location: SPLocation)
}

final class SPLocationView: UIView {
    
    public weak var delegate: SPLocationViewDelegate?
    
    private var viewModel: SPLocationViewViewModel? {
        didSet {
            spinner.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
            
            
            DispatchQueue.main.async {
                self.viewModel?.registerDidFinishPaginationBlock { [weak self] in
                    self?.tableView.tableFooterView = nil
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(SPLocationTableViewCell.self, forCellReuseIdentifier: SPLocationTableViewCell.cellIdentifier)
        table.alpha = 0
        table.isHidden = true
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView, spinner)
        spinner.startAnimating()
        addConstraints()
        configureTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    public func configure(with viewModel: SPLocationViewViewModel) {
        self.viewModel = viewModel
    }
}
//MARK: - UITableViewDelegate

extension SPLocationView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let locationModel = viewModel?.location(at: indexPath.row) else { return }
        
        delegate?.spLocationView(self, didSelect: locationModel)
    }
}

//MARK: - UITableViewDataSource

extension SPLocationView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let bounds = UIScreen.main.bounds
       
        return UIDevice.isiPhone ? 240 : bounds.height / 1.7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModels = viewModel?.cellViewModels else {
            fatalError()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SPLocationTableViewCell.cellIdentifier, for: indexPath) as? SPLocationTableViewCell else { fatalError() }
        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
}
// MARK: - UIScrollViewDelegate

extension SPLocationView: UIScrollViewDelegate {
    func scrollViewDidScroll
    (_ scrollView: UIScrollView) {
        guard let viewModel = viewModel else { return }
        guard viewModel.shouldShowLoadMoreIndicator, !viewModel.isLoadingMoreLocations, !viewModel.cellViewModels.isEmpty else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.showLoadingIndicator()
                
                viewModel.fetchAdditionalLocations()
            }
            t.invalidate()
        }
    }
    
    private func showLoadingIndicator() {
        let footer = SPTableLoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 100))
        tableView.tableFooterView = footer
    }
}


