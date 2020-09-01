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
    var birdImageURL: String?
    var botanicalImageURL: String?
    var flickerBirdImageData: FlickerSearchResult? {
        didSet {
            loadBirdFlickerPhoto(for: (flickerBirdImageData?.photos.photo)!)
        }
    }
    var flickerPlantImageData: FlickerSearchResult? {
        didSet {
            loadFlickerPlantPhoto(for: (flickerPlantImageData?.photos.photo)!)
        }
    }
    var flickerBirdImageURL: String?
    var flickerPlantImageURL: String?
    var randomPair = ""
    var randomBird = "" {
        didSet {
            birdNameLabel.text = "\(randomBird)"
        }
    }
    var randomPlant = "" {
        didSet {
            plantNameLabel.text = "\(randomPlant)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBirdData()
        loadBotanicalData()
        configureUI()
    }
    private func configureUI() {
        birdImageView.layer.masksToBounds = false
        plantImageView.layer.masksToBounds = false
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
        randomBird = birdData?.randomElement()?.commonName ?? "Bird"
        randomPlant = botanicalData?.randomElement()?.name ?? "Botanical"
//        getPixaBayBirdPhoto(for: randomBird)
//        getPixaBayBotanicalPhoto(for: randomBotanical)
        searchFlickerBirdPhotos(for: randomBird)
        searchFlickerPlantPhotos(for: randomPlant)
        randomPair = "\(randomBird) \(randomPlant)"
    }
    private func generateRandomBird() {
        searchFlickerBirdPhotos(for: randomBird)
        randomBird = birdData?.randomElement()?.commonName ?? "BIRD"
    }
    private func generateRandomPlant() {
        searchFlickerPlantPhotos(for: randomPlant)
        randomPlant = botanicalData?.randomElement()?.name ?? "PLANT"
    }
    private func getPixaBayBirdPhoto(for bird: String) {
        PixaBayAPI.getPhotos(searchQuery: bird) { (results) in
            switch results {
            case .failure(let appError):
                print("Failed to load bird photo: \(appError)")
            case .success(let image):
                self.birdImageURL = image.hits.first?.previewURL
            }
        }
    }
    private func loadBirdPhotoURL(with url: String) {
        DispatchQueue.main.async {
            self.birdImageView.kf.indicatorType = .activity
            self.birdImageView.kf.setImage(with: URL(string: url))
        }

    }
    private func loadPlantPhotoURL(with url: String) {
        DispatchQueue.main.async {
            self.plantImageView.kf.indicatorType = .activity
            self.plantImageView.kf.setImage(with: URL(string: url))
        }

    }
    private func getPixaBayBotanicalPhoto(for plant: String) {
        PixaBayAPI.getPhotos(searchQuery: plant) { (results) in
            switch results {
            case .failure(let appError):
                print("Failed to load bird photo: \(appError)")
            case .success(let image):
                self.botanicalImageURL = image.hits.first?.largeImageURL
            }
        }
    }
    //MARK:- Flicker functions
    private func searchFlickerBirdPhotos(for query: String) {
        FlickerAPI.searchPhotos(searchQuery: query) { (results) in
            switch results {
            case .failure(let appError):
                print("Failed to search flicker for a photo: \(appError)")
            case .success(let results):
                self.flickerBirdImageData = results
            }
        }
    }
    private func searchFlickerPlantPhotos(for query: String) {
        FlickerAPI.searchPhotos(searchQuery: query) { (results) in
            switch results {
            case .failure(let appError):
                print("Failed to search flicker for a photo: \(appError)")
            case .success(let results):
                self.flickerPlantImageData = results
            }
        }
    }
    private func loadBirdFlickerPhoto(for photo: [PhotoResult]) {
        let flickerPhotoEndpoint = "https://farm\(photo.first?.farm ?? 0).staticflickr.com/\(photo.first?.server ?? "")/\(photo.first?.id ?? "")_\(photo.first?.secret ?? "")_m.jpg".lowercased()
        loadBirdPhotoURL(with: flickerPhotoEndpoint)
//        FlickerAPI.getUserPhotoURL(photoID: photo.first?.id ?? "", photoSecret: photo.first?.secret ?? "", farm: photo.first?.farm ?? 0, server: photo.first?.server ?? "0") { (results) in
//            switch results {
//            case .failure(let appError):
//                print("Failed to search flicker for a photo: \(appError)")
//            case .success(let results):
//                self.flickerBirdImageURL = results.photo.urls.url.first?.content
//            }
//        }
    }
    private func loadFlickerPlantPhoto(for photo: [PhotoResult]) {
        let flickerPhotoEndpoint = "https://farm\(photo.first?.farm ?? 0).staticflickr.com/\(photo.first?.server ?? "")/\(photo.first?.id ?? "")_\(photo.first?.secret ?? "")_m.jpg".lowercased()
        loadPlantPhotoURL(with: flickerPhotoEndpoint)
//        FlickerAPI.getUserPhotoURL(photoID: photo.first?.id ?? "", photoSecret: photo.first?.secret ?? "", farm: photo.first?.farm ?? 0, server: photo.first?.server ?? "0") { (results) in
//            switch results {
//            case .failure(let appError):
//                print("Failed to search flicker for a photo: \(appError)")
//            case .success(let results):
//                self.flickerPlantImageURL = results.photo.urls.url.first?.content
//            }
//        }
    }
    @IBAction func shuffleButtonPressed(_ sender: UIButton) {
        generateRandomPair()
    }
    @IBAction func randomBirdButtonPressed(_ sender: UIButton) {
        generateRandomBird()
    }
    @IBAction func randomPlantButtonPressed(_ sender: UIButton) {
        generateRandomPlant()
    }
    
}
