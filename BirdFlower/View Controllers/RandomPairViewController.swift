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
    case duo
}

@IBDesignable class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
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
    var birdData: [BirdsSpecies]?
    var plantData: [PlantsSpecies]?
    var birdImageURL: String?
    var plantImageURL: String?
    var flickerBirdImageData: FlickerSearchResult? {
        didSet {
            guard let photo = flickerBirdImageData?.photos.photo, !photo.isEmpty else {
                DispatchQueue.main.async {
                    self.birdImageView.contentMode = .scaleAspectFit
                    self.birdImageView.tintColor = .white
                    self.birdImageView.image = UIImage(systemName: "questionmark")
                }
                return
            }
            loadBirdFlickerPhoto(for: photo)
        }
    }
    var flickerPlantImageData: FlickerSearchResult? {
        didSet {
            guard let photo = flickerPlantImageData?.photos.photo, !photo.isEmpty else {
                DispatchQueue.main.async {
                    self.plantImageView.contentMode = .scaleAspectFit
                    self.plantImageView.tintColor = .white
                    self.plantImageView.image = UIImage(systemName: "questionmark")
                }
                return
            }
            loadFlickerPlantPhoto(for: photo)
        }
    }
    
    var flickerBirdImageURL: String?
    var flickerPlantImageURL: String?
    var randomPair: FavoriteDuo?
    var randomBird: BirdsSpecies? {
        didSet {
            birdNameLabel.text = "\(randomBird?.commonName ?? "Bird")"
        }
    }
    var randomPlant: PlantsSpecies? {
        didSet {
            plantNameLabel.text = "\(randomPlant?.name ?? "Plant")"
        }
    }
    var isFavorite: Bool = false
    var favoriteDuos: [FavoriteDuo]? {
        didSet {
            
        }
    }
    //MARK: dataPersistence Instance
    var dataPersistence: DataPersistence<FavoriteDuo>?
    
    //MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataPersistence()
        loadBirdData()
        loadPlantData()
//        configureUI()
        fetchFavoriteDuos()
        generateRandomPair()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    //MARK:- Funcs
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

        
    }
    private func generateRandomBird() {
        randomBird = birdData?.randomElement()
        makeRandomPair()
        searchFlickerPhotos(for: randomBird?.commonName ?? "", searchType: .bird)
    }
    private func generateRandomPlant() {
        randomPlant = plantData?.randomElement()
        makeRandomPair()
        searchFlickerPhotos(for: randomPlant?.name ?? "", searchType: .plant)
    }
    private func makeRandomPair() {
        randomPair = FavoriteDuo(birdCommonName: randomBird?.commonName ?? "Bird", birdScientificName: randomBird?.scientificName ?? "Scientific name", plantName: randomPlant?.name ?? "Plant name")
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
     if searchType == .bird {
            FlickerAPI.searchPhotos(searchQuery: query, contentType: .birds) { [weak self] (results) in
                switch results {
                case .failure(let appError):
                    print("Failed to search flicker for a photo: \(appError)")
                    DispatchQueue.main.async {
                        if searchType == .bird {
                            self?.birdImageView.isHidden = true
                        } else if searchType == .plant {
                            self?.plantImageView.isHidden = true
                        }
                    }
                case .success(let results):
                    self?.flickerBirdImageData = results
                }
            }
        } else if searchType == .plant {
            FlickerAPI.searchPhotos(searchQuery: query, contentType: .plants) { [weak self] (results) in
                switch results {
                case .failure(let appError):
                    print("Failed to search flicker for a photo: \(appError)")
                    DispatchQueue.main.async {
                        if searchType == .bird {
                            self?.birdImageView.isHidden = true
                        } else if searchType == .plant {
                            self?.plantImageView.isHidden = true
                        }
                    }
                case .success(let results):
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
    private func setupDataPersistence() {
        if let tabBarController = self.tabBarController as? MainTabBarController {
            dataPersistence = tabBarController.dataPersistence
        }
    }
    private func resetFavoriteButton() {
        isFavorite = false
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    //MARK:- IBActions
    @IBAction func shuffleButtonPressed(_ sender: UIButton) {
        isFavorite = false
        resetFavoriteButton()
        generateRandomPair()
    }
    @IBAction func randomBirdButtonPressed(_ sender: UIButton) {
        resetFavoriteButton()
        generateRandomBird()
    }
    @IBAction func randomPlantButtonPressed(_ sender: UIButton) {
        resetFavoriteButton()
        generateRandomPlant()
    }
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        isFavorite.toggle()
        if isFavorite {
            do {
                try dataPersistence?.createItem(randomPair!)
                showAlert(title: "Success!", message: "Favorite saved")
                favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                favoriteButton.tintColor = #colorLiteral(red: 0.8201736992, green: 0.1226904487, blue: 0.007086123212, alpha: 1)
            } catch {
                showAlert(title: "Oops!", message: "Something went wrong. Maybe write this one down...")
            }
        } else {
            guard let index = favoriteDuos?.firstIndex(of: randomPair!) else {
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
    @IBAction func aboutButtonPressed(_ sender: UIButton) {
        if let aboutVC = UIStoryboard(name: "AboutViewController", bundle: nil).instantiateViewController(identifier: "aboutViewController") as? AboutViewController {
            if let navigator = navigationController {
                navigator.navigationBar.prefersLargeTitles = true
                navigator.pushViewController(aboutVC, animated: true)
            }
        }
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = true
    }
}

//MARK:- Extensions
extension RandomPairViewController: PersistenceStackClient {
    func setStack(stack: DataPersistence<String>) {
//        self.dataPersistence = stack
    }
}
