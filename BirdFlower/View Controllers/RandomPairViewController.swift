//
//  RandomPairViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 8/31/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import Kingfisher

class RandomPairViewController: UIViewController {

    @IBOutlet weak var birdNameLabel: UILabel!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var birdImageView: UIImageView!
    
    var birdData: [BirdsSpecies]?
    var botanicalData: [Flowers]?
    var birdImageURL: String? {
        didSet {
            loadBirdPhoto()
        }
    }
    var botanicalImageURL: String? {
        didSet {
            loadPlantPhoto()
        }
    }
    var randomPair = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBirdData()
        loadBotanicalData()
        configureUI()
    }
    private func configureUI() {
//        birdImageView.layer.masksToBounds = false
//        plantImageView.layer.masksToBounds = false
        birdImageView.layer.borderWidth = 1.0
        plantImageView.layer.borderWidth = 1.0
        birdImageView.layer.borderColor = UIColor.white.cgColor
        plantImageView.layer.borderColor = UIColor.white.cgColor
        birdImageView.clipsToBounds = true
        plantImageView.clipsToBounds = true
        birdImageView.layer.cornerRadius = birdImageView.frame.width / 2.1
        plantImageView.layer.cornerRadius = plantImageView.frame.width / 2.10
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
        getBirdPhoto(for: randomBird)
        getBotanicalPhoto(for: randomBotanical)
        randomPair = "\(randomBird) \(randomBotanical)"
        birdNameLabel.text = "\(randomBird)"
        plantNameLabel.text = "\(randomBotanical)"
        
    }
    private func getBirdPhoto(for bird: String) {
        PixaBayAPI.getPhotos(searchQuery: bird) { (results) in
            switch results {
            case .failure(let appError):
                print("Failed to load bird photo: \(appError)")
            case .success(let image):
                
                self.birdImageURL = image.hits.first?.previewURL
            }
        }
    }
    private func loadBirdPhoto() {
        DispatchQueue.main.async {
            self.birdImageView.kf.indicatorType = .activity
            self.birdImageView.kf.setImage(with: URL(string: self.birdImageURL ?? ""))
        }

    }
    private func loadPlantPhoto() {
        DispatchQueue.main.async {
            self.plantImageView.kf.indicatorType = .activity
            self.plantImageView.kf.setImage(with: URL(string: self.botanicalImageURL ?? ""))
        }
    }
    private func getBotanicalPhoto(for plant: String) {
        PixaBayAPI.getPhotos(searchQuery: plant) { (results) in
            switch results {
            case .failure(let appError):
                print("Failed to load bird photo: \(appError)")
            case .success(let image):
                self.botanicalImageURL = image.hits.first?.largeImageURL
            }
        }
    }
    @IBAction func shuffleButtonPressed(_ sender: UIButton) {
        generateRandomPair()
    }
    
}
