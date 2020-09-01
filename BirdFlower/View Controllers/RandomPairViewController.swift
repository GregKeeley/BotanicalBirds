//
//  RandomPairViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 8/31/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

class RandomPairViewController: UIViewController {

    @IBOutlet weak var birdNameLabel: UILabel!
    @IBOutlet weak var plantNameLabel: UILabel!
    
    var birdData: [BirdsSpecies]?
    var botanicalData: [Flowers]?
    
    var randomPair = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBirdData()
        loadBotanicalData()
    }
    private func loadBirdData() {
        birdData = BirdsSpecies.decodeBirdSpeciesData()
    }
    private func loadBotanicalData() {
        botanicalData = Flowers.decodeFlowers()
    }
    private func generateRandomPair() {
        let randomBird = birdData?.randomElement()?.commonName ?? "Bird"
        let randomBotanical = botanicalData?.randomElement()?.name ?? "Botanical"
        randomPair = "\(randomBird) \(randomBotanical)"
        birdNameLabel.text = "\(randomBird)"
        plantNameLabel.text = "\(randomBotanical)"
    }
    @IBAction func shuffleButtonPressed(_ sender: UIButton) {
        generateRandomPair()
    }
    
}
