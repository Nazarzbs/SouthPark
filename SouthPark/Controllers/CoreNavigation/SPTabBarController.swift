//
//  ViewController.swift
//  SouthPark
//
//  Created by Nazar on 11.05.2023.
//

import UIKit

//final because it can't be subclassed

/// Controller to house tabs and root tab controllers
final class SPTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabs()
    }

//private to not allow other class access it
    private func setUpTabs() {
        //make instances and attach them to our tabBar
        let charactersVC = SPCharacterViewController()
        let episodesVC = SPEpisodeViewController()
        let familiesVC = SPFamilyViewController()
        let locationsVC = SPLocationViewController()
        let settingsVC = SPSettingsViewController()
        
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        locationsVC.navigationItem.largeTitleDisplayMode = .automatic
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        familiesVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        //To show nice title bar
        let nav1 = UINavigationController(rootViewController: charactersVC)
        let nav2 = UINavigationController(rootViewController: locationsVC)
        let nav3 = UINavigationController(rootViewController: episodesVC)
        let nav4 = UINavigationController(rootViewController: familiesVC)
        let nav5 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person.text.rectangle"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "globe.americas"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Families", image: UIImage(systemName: "figure.2.and.child.holdinghands"), tag: 4)
        nav5.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 5)
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2, nav3, nav4, nav5], animated: true)
    }
}

