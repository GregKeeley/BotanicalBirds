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
    var birdImage: UIImage!
    var plantImage: UIImage!
    
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
    
    //MARK:- Functions
    private func setupUI() {
        birdCommonNameLabel.text = duo?.birdCommonName
        birdScientificNameLabel.text = duo?.birdScientificName
        plantNameLabel.text = duo?.plantName
        searchFlickerImageData()
        
        birdImageView.layer.borderColor = UIColor.white.cgColor
        birdImageView.layer.borderWidth = 1
        plantImageView.layer.borderWidth = 1
        plantImageView.layer.borderColor = UIColor.white.cgColor
        plantImageView.layer.cornerRadius = 8
        birdImageView.layer.cornerRadius = 8
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
            if let navigator = navigationController {
                navigator.pushViewController(imageZoomVC, animated: true)
            }
        }
    }
    @IBAction func plantButtonPressed(_ sender: UIButton) {
        if let imageZoomVC = UIStoryboard(name: "ImageZoomViewController", bundle: nil).instantiateViewController(identifier: "ImageZoomViewController") as? ImageZoomViewController {
            imageZoomVC.imageData = flickerPlantImageData
            if let navigator = navigationController {
                navigator.pushViewController(imageZoomVC, animated: true)
            }
        }
    }
    
}
//MARK:- Extensions

