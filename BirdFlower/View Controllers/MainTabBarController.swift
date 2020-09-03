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
    private var dataPersistence = DataPersistence<String>(filename: "favoritePairs.plist")
    
    //MARK:- View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}
