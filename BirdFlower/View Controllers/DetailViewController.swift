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
    var duo: FavoriteDuo?
    //    var bird = ""
    //    var plant = ""
    
    //MARK:- Init
    init(duo: FavoriteDuo) {
        self.duo = duo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK:- Functions
    private func setupUI() {
        birdCommonNameLabel.text = duo?.birdCommonName
        birdScientificNameLabel.text = duo?.birdScientificName
        plantNameLabel.text = duo?.plantName
    }
    
    
}
//MARK:- Extensions

