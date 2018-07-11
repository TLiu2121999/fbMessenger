//
//  CustomTabBarController.swift
//  fbMessenger
//
//  Created by Tongtong Liu on 7/10/18.
//  Copyright © 2018 Tongtong Liu. All rights reserved.
//

import UIKit
class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsViewController(collectionViewLayout: layout)
        let recentMessageNavController = UINavigationController(rootViewController: friendsController)
        recentMessageNavController.tabBarItem.title = "Recent"
        recentMessageNavController.tabBarItem.image = UIImage(named: "recent")
        
        viewControllers = [recentMessageNavController, createDummyNavControllerWithTitle(title: "Calls", image: "call"),createDummyNavControllerWithTitle(title: "Groups", image: "group"),createDummyNavControllerWithTitle(title: "People", image: "people"),createDummyNavControllerWithTitle(title: "Settings", image: "settings")]

    }
    
    private func createDummyNavControllerWithTitle(title: String, image: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: image)
        
        return navController
        
    }
}
