//
//  RandomPairViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 8/31/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import Kingfisher
import DataPersistence

enum SearchType {
    case bird
    case plant
}
protocol FavoriteSelectedDelegate: AnyObject {
    func favoritesAreSelected(favorites: [String])
}
class RandomPairViewController: UIViewController {
//MARK:- IBOutlets
    @IBOutlet weak var birdNameLabel: UILabel!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var birdImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    
    //MARK:- Variables
    weak var favoritesSelectionDelegate: FavoriteSelectedDelegate?
    
    var birdData: [BirdsSpecies]?
    var plantData: [PlantsSpecies]?
    var birdImageURL: String?
    var plantImageURL: String?
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
    var isFavorite: Bool = false
    
    var dataPersistence: DataPersistence<String>!
    var persistenceDelegate: PersistenceStackClientDelegate?
    
    var favoriteDuos: [String]? {
        didSet {
            favoritesSelectionDelegate?.favoritesAreSelected(favorites: favoriteDuos ?? [])
        }
    }
    
    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBirdData()
        loadPlantData()
        configureUI()
        fetchFavoriteDuos()
        generateRandomPair()
        persistenceDelegate = self
    }
    //MARK:- Funcs
    private func configureUI() {
        birdImageView.layer.masksToBounds = false
        plantImageView.layer.masksToBounds = false
        birdImageView.layer.borderWidth = 1.0
        plantImageView.layer.borderWidth = 1.0
        birdImageView.layer.borderColor = UIColor.white.cgColor
        plantImageView.layer.borderColor = UIColor.white.cgColor
        birdImageView.clipsToBounds = true
        plantImageView.clipsToBounds = true
        birdImageView.layer.cornerRadius = birdImageView.frame.height / 2.09
        plantImageView.layer.cornerRadius = plantImageView.frame.height / 2.08
        
        shuffleButton.layer.cornerRadius = 8
    }
    // These functions generate random pairs, or individually random data to use in the app
    private func fetchFavoriteDuos() {
        do {
            favoriteDuos = try dataPersistence?.loadItems()
            print("favorites: \(favoriteDuos?.count ?? -1 )")
        } catch {
            showAlert(title: "Well, this is embarassing", message: "Failed to load favorites...")
        }
    }
    private func loadBirdData() {
        birdData = BirdsSpecies.decodeBirdSpeciesData()
    }
    private func loadPlantData() {
        plantData = PlantsSpecies.decodeFlowers()
    }
    private func generateRandomPair() {
        generateRandomBird() // getting a random Bird, then its searching flicker
        generateRandomPlant()
//        searchFlickerPhotos(for: randomBird, searchType: .bird)
//        searchFlickerPhotos(for: randomPlant, searchType: .plant)
        randomPair = "\(randomBird) + \(randomPlant)"
    }
    private func generateRandomBird() {
        randomBird = birdData?.randomElement()?.commonName ?? "BIRD"
        searchFlickerPhotos(for: randomBird, searchType: .bird)
    }
    private func generateRandomPlant() {
        randomPlant = plantData?.randomElement()?.name ?? "PLANT"
        searchFlickerPhotos(for: randomPlant, searchType: .plant)
    }
    
    /// Sets the image view using KingFisher to set a UIImageView
    ///
    /// - Parameters:
    ///   - url: URL address for the pic generated from the search func
    ///   - imageView: The UIImageView that needs to be set
    private func loadPhotoFromURL(with url: String, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: url))
        }
    }
    //MARK:- Flicker functions
    private func searchFlickerPhotos(for query: String, searchType: SearchType) {
        FlickerAPI.searchPhotos(searchQuery: query) { [weak self] (results) in
            switch results {
            case .failure(let appError):
                print("Failed to search flicker for a photo: \(appError)")
                DispatchQueue.main.async {
                    if searchType == .bird {
                        self?.birdImageView.image = UIImage(systemName: "questionmark.circle")
                    } else if searchType == .plant {
                        self?.plantImageView.image = UIImage(systemName: "questionmark.circle")
                    }
                }
            case .success(let results):
                if searchType == .bird {
                    self?.flickerBirdImageData = results
                } else if searchType == .plant {
                    self?.flickerPlantImageData = results
                }
            }
        }
    }

    private func loadBirdFlickerPhoto(for photo: [PhotoResult]) {
        let flickerPhotoEndpoint = "https://farm\(photo.first?.farm ?? 0).staticflickr.com/\(photo.first?.server ?? "")/\(photo.first?.id ?? "")_\(photo.first?.secret ?? "")_m.jpg".lowercased()
        loadPhotoFromURL(with: flickerPhotoEndpoint, imageView: birdImageView)
    }
    private func loadFlickerPlantPhoto(for photo: [PhotoResult]) {
        let flickerPhotoEndpoint = "https://farm\(photo.first?.farm ?? 0).staticflickr.com/\(photo.first?.server ?? "")/\(photo.first?.id ?? "")_\(photo.first?.secret ?? "")_m.jpg".lowercased()
        loadPhotoFromURL(with: flickerPhotoEndpoint, imageView: plantImageView)
    }
    //MARK:- IBActions
    @IBAction func shuffleButtonPressed(_ sender: UIButton) {
        isFavorite = false
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        generateRandomPair()
    }
    @IBAction func randomBirdButtonPressed(_ sender: UIButton) {
        generateRandomBird()
    }
    @IBAction func randomPlantButtonPressed(_ sender: UIButton) {
        generateRandomPlant()
    }
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        isFavorite.toggle()
        if isFavorite {
            do {
                try dataPersistence?.createItem(randomPair)
                showAlert(title: "Success!", message: "Favorite saved")
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = #colorLiteral(red: 0.8201736992, green: 0.1226904487, blue: 0.007086123212, alpha: 1)
            } catch {
                showAlert(title: "Oops!", message: "Something went wrong. Maybe write this one down...")
            }
        } else {
            guard let index = favoriteDuos?.firstIndex(of: randomPair) else {
                showAlert(title: "Could not find favorite", message: "Failed to remove favorite, or it wasn't a favorite to begin with")
                favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
                favoriteButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                return
            }
            do {
                try dataPersistence?.deleteItem(at: index)
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            favoriteButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } catch {
                showAlert(title: "Failed to remove favorite", message: "Your guess is as good as mine")
            }
        }
        fetchFavoriteDuos()
    }
    
}
extension RandomPairViewController: PersistenceStackClientDelegate {
    func setStack(stack: DataPersistence<String>) {
        self.dataPersistence = stack
    }
}
