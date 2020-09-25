//
//  UILabel_Extension.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 9/24/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

extension UILabel {
    func createShadows() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.masksToBounds = false
    }
}
