//
//  MainTabBarController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 9/3/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import DataPersistence

protocol PersistenceStackClient {
    func setStack(stack: DataPersistence<String>)
}

class MainTabBarController: UITabBarController {
    
    var dataPersistence = DataPersistence<FavoriteDuo>(filename: "favorites.plist")
    
    //MARK:- View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    }
    
}
