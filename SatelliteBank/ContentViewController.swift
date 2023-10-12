//
//  ContentViewController.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

protocol ContentViewControllerDelegate: UIViewController {
    
    func searchBarTextDidBeginEditing()
    
}

final class ContentViewController: UIViewController {
    
    weak var delegate: ContentViewControllerDelegate?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.navigationItem.searchController = searchController
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
//        self.searchController.automaticallyShowsCancelButton = true
//        self.searchController.searchBar.showsCancelButton = true
        
        let button = UIBarButtonItem(title: "Test", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = button
        
        let bar = UIButton()
        bar.setTitle("SDFSDF", for: .normal)
        
        self.searchController.searchBar.addSubview(bar)
        
//        for searchButton in self.searchController.searchBar.subviews {
//            guard let searchButton = searchButton as? UINavigationButton else { return }
//            searchButton.isEnabled = true
//            let image = UIImage(named: "location")
//            searchButton.setBackgroundImage(image, for: .normal)
//            break
//        }
        
//        for (UIView *searchbuttons in searchBar.subviews)
//            {
//                if ([searchbuttons isKindOfClass:[UIButton class]])
//                {
//                    UIButton *cancelButton = (UIButton*)searchbuttons;
//                    cancelButton.enabled = YES;
//                    [cancelButton setBackgroundImage:[UIImage imageNamed:@"yourImageName"] forState:UIControlStateNormal];
//                    break;
//                }
//            }
        
        self.searchBar.searchBarStyle = .minimal
        
//        self.layout()
    }
    
    var searchBar: UISearchBar {
        self.searchController.searchBar
    }
    
//    var searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.searchBarStyle = .minimal
////        searchBar.backgroundImage = nil
////        searchBar.backgroundColor = .clear
//        return searchBar
//    }()
    
    private func layout() {
        self.view.addSubview(self.searchBar)
        
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8).isActive = true
        self.searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8).isActive = true
        self.searchBar.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        self.searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
//        self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8).isActive = true
        
        
        
        
        
    }
    
    
}

extension ContentViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.delegate?.searchBarTextDidBeginEditing()
    }
}
