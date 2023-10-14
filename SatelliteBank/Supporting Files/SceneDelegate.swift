//
//  SceneDelegate.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let mapViewController = self.createMapViewController()
        
        let favoriteViewController = self.createFavoriteViewController()
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
        
//        let bankContentViewController = self.createBankContentViewController()
        
//        let prepareRouteViewController = PrepareRouteViewController()
        
        
        self.window = UIWindow(windowScene: scene)
        
        self.window?.rootViewController = mapViewController
        
        
        let loginViewController = LoginViewController()
        
        let tabViewController = TabViewController()
        
        tabViewController.setViewControllers([mapViewController, favoriteNavigationController], animated: false)
        tabViewController.selectedIndex = 0
        
        self.window?.rootViewController = tabViewController
        
        self.window?.makeKeyAndVisible()
        
    }
    
    func createMapViewController() -> MapViewController {
        
        let viewController = MapViewController()
        viewController.viewModel = MapViewModel()
        viewController.tabBarItem = UITabBarItem(title: "Обзор", image: UIImage(systemName: "map.fill"), tag: 0)
        
        return viewController
        
    }
    
    func createFavoriteViewController() -> FavoriteViewController {
        
        let viewController = FavoriteViewController()
        viewController.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "heart.fill"), tag: 1)
        
        return viewController
        
    }
    
//    func createBankContentViewController() -> BankContentViewController {
        
        
//        let bank = Bank(title: "Филиал Банка ВТБ (ПАО) № 7806", address: "г. Санкт-Петербург, ул. Наличная, д.51, лит. А")
//        let viewModel = BankContentViewModel(bank: bank)
//
//        let viewController = BankContentViewController()
//        viewController.viewModel = viewModel
//        viewController.tabBarItem = UITabBarItem(title: "Банк", image: UIImage(systemName: "house.fill"), tag: 2)
//
//        return viewController
//
        
//    }

}

