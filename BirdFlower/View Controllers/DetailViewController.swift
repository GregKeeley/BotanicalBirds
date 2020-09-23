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
    @IBOutlet weak var birdImageButton: UIButton!
    @IBOutlet weak var plantImageButton: UIButton!
    
    //MARK:- Variables and Constants
    var duo: FavoriteDuo?
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
    
    //MARK:- Init
    init(duo: FavoriteDuo) {
        self.duo = duo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK:- View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.barTintColor = .white
    }
    //MARK:- Functions
    private func setupUI() {
        birdCommonNameLabel.text = duo?.birdCommonName
        birdScientificNameLabel.text = duo?.birdScientificName
        plantNameLabel.text = duo?.plantName
        searchFlickerImageData()
        
//        birdImageView.layer.borderColor = UIColor.white.cgColor
//        birdImageView.layer.borderWidth = 1
//        plantImageView.layer.borderWidth = 1
//        plantImageView.layer.borderColor = UIColor.white.cgColor
        plantImageView.layer.cornerRadius = 4
        birdImageView.layer.cornerRadius = 4
    }
    
    private func searchFlickerImageData() {
        searchFlickerPhotos(for: duo?.birdCommonName ?? "", searchType: .bird)
        searchFlickerPhotos(for: duo?.plantName ?? "", searchType: .plant)
    }
    private func searchFlickerPhotos(for query: String, searchType: SearchType) {
        if searchType == .bird {
            FlickerAPI.searchPhotos(searchQuery: query, contentType: .birds) { [weak self] (results) in
                switch results {
                case .failure(let appError):
                    print("Failed to search flicker for a photo: \(appError)")
                    DispatchQueue.main.async {
                        if searchType == .bird {
                            self?.birdImageView.isHidden = true
                            self?.birdImageButton.isEnabled = false
                        } else if searchType == .plant {
                            self?.plantImageView.isHidden = true
                            self?.plantImageButton.isEnabled = false
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
                            self?.birdImageButton.isEnabled = false
                        } else if searchType == .plant {
                            self?.plantImageView.isHidden = true
                            self?.plantImageButton.isEnabled = false
                        }
                    }
                case .success(let results):
                    self?.flickerPlantImageData = results
                }
            }
        }
    }
    
    private func loadPhotoFromURL(with url: String, imageView: UIImageView) {
        DispatchQueue.main.async {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: URL(string: url))
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
    @IBAction func birdButtonPressed(_ sender: UIButton) {
        if let imageZoomVC = UIStoryboard(name: "ImageZoomViewController", bundle: nil).instantiateViewController(identifier: "ImageZoomViewController") as? ImageZoomViewController {
            imageZoomVC.imageData = flickerBirdImageData
            imageZoomVC.nameForPhoto = duo?.birdCommonName ?? "Bird"
            if let navigator = navigationController {
                navigator.navigationController?.navigationBar.prefersLargeTitles = false
//                navigator.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
                navigator.navigationController?.navigationBar.topItem?.title = duo?.birdCommonName ?? "Bird"
                navigator.pushViewController(imageZoomVC, animated: true)
            }
        }
    }
    @IBAction func plantButtonPressed(_ sender: UIButton) {
        if let imageZoomVC = UIStoryboard(name: "ImageZoomViewController", bundle: nil).instantiateViewController(identifier: "ImageZoomViewController") as? ImageZoomViewController {
            imageZoomVC.imageData = flickerPlantImageData
            imageZoomVC.nameForPhoto = duo?.plantName ?? "Plant"
            if let navigator = navigationController {
                navigator.navigationController?.navigationBar.prefersLargeTitles = false
                navigator.navigationController?.navigationBar.tintColor = .white
                navigator.navigationController?.navigationItem.title = duo?.plantName ?? "Plant"
                navigator.pushViewController(imageZoomVC, animated: true)
            }
        }
    }
    
}
//MARK:- Extensions

