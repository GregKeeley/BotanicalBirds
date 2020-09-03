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
    //MARK:- View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    


}
