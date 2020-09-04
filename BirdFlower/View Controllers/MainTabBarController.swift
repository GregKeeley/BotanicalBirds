//
//  MainTabBarController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 9/3/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import DataPersistence

protocol PersistenceStackClientDelegate: AnyObject {
    func setStack(stack: DataPersistence<String>)
}

class MainTabBarController: UITabBarController {
    
    var dataPersistence = DataPersistence<String>(filename: "favorites.plist")

    weak var persistenceDelegate: PersistenceStackClientDelegate?
    
    //MARK:- View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        persistenceDelegate?.setStack(stack: dataPersistence)
        configureUI()
        
    }

    private func configureUI() {
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    }
    
}
