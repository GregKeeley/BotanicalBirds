//
//  DetailViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 9/6/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
   //MARK:- IBOutlets
    @IBOutlet weak var birdImageView: UIImageView!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var birdCommonNameLabel: UILabel!
    @IBOutlet weak var birdScientificNameLabel: UILabel!
    @IBOutlet weak var plantNameLabel: UILabel!
    
    //MARK:- Variables and Constants
    var duo = ""
    var bird = ""
    var plant = ""
    
    //MARK:- View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:- Functions
    private func setupUI() {
    }


}
//MARK:- Extensions

