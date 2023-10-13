//
//  MapContentViewController.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

protocol ContentViewControllerDelegate: UIViewController {
    
    func searchBarTextDidBeginEditing()
    
}

final class MapContentViewController: UIViewController {
    
    weak var delegate: ContentViewControllerDelegate?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBar: UISearchBar {
        self.searchController.searchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
    }

    private func setupSearchController() {
        self.definesPresentationContext = true
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        self.searchController.searchBar.placeholder = "Поиск"
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        self.searchBar.searchBarStyle = .minimal
    }
    
    
}

extension MapContentViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.delegate?.searchBarTextDidBeginEditing()
    }
}
