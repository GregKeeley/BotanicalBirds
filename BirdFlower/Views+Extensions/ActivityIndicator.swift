//
//  ActivityIndicator.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 10/6/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
    override func loadView() {
        view = UIView()
        
        view.backgroundColor = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
