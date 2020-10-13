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
    var birdImage: UIImage?
    var plantImage: UIImage?
    
    var flickerBirdImageData: FlickerSearchResult? {
        didSet {
            guard let photo = flickerBirdImageData?.photos.photo, duo?.birdCommonName != "" else {
                DispatchQueue.main.async {
                    self.birdImageView.contentMode = .scaleAspectFit
                    self.birdImageView.tintColor = .white
//                    self.birdImageView.image = UIImage(systemName: "questionmark")
                    self.birdImageView.image = nil
                }
                return
            }
            loadBirdFlickerPhoto(for: photo)
        }
    }
    var flickerPlantImageData: FlickerSearchResult? {
        didSet {
            guard let photo = flickerPlantImageData?.photos.photo, duo?.plantName != "" else {
                DispatchQueue.main.async {
                    self.plantImageView.contentMode = .scaleAspectFit
                    self.plantImageView.tintColor = .white
//                    self.plantImageView.image = UIImage(systemName: "questionmark")
                    self.plantImageView.image = nil
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
        navigationController?.navigationBar.barTintColor = .systemBackground
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    //MARK:- Functions
    private func setupUI() {
        birdCommonNameLabel.text = duo?.birdCommonName
        birdScientificNameLabel.text = duo?.birdScientificName
        plantNameLabel.text = duo?.plantName
        searchFlickerImageData()
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
                    self?.showAlert(title: "Error", message: "\(appError.localizedDescription)")
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
                    self?.showAlert(title: "Error", message: "\(appError.localizedDescription)")
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
        if imageView == self.birdImageView {
            self.birdImageView.getImage(with: url, completion: { [weak self] (results) in
                switch results {
                case .failure(let appError):
                    self?.showAlert(title: "Error", message: "\(appError.localizedDescription)")
                case .success(let image):
                    self?.birdImage = image
                    DispatchQueue.main.async {
                        self?.birdImageView.image = image
                    }
                }
            })
        } else {
            self.plantImageView.getImage(with: url, completion: { [weak self] (results) in
                switch results {
                case .failure(let appError):
                    self?.showAlert(title: "Error", message: "\(appError.localizedDescription)")
                case .success(let image):
                    self?.plantImage = image
                    DispatchQueue.main.async {
                        self?.plantImageView.image = image
                    }
                }
            })
        }
    }
    private func loadBirdFlickerPhoto(for photo: [PhotoResult]) {
        let flickerPhotoEndpoint = "https://farm\(photo.first?.farm ?? 0).staticflickr.com/\(photo.first?.server ?? "")/\(photo.first?.id ?? "")_\(photo.first?.secret ?? "")_b.jpg".lowercased()
        loadPhotoFromURL(with: flickerPhotoEndpoint, imageView: birdImageView)
    }
    private func loadFlickerPlantPhoto(for photo: [PhotoResult]) {
        let flickerPhotoEndpoint = "https://farm\(photo.first?.farm ?? 0).staticflickr.com/\(photo.first?.server ?? "")/\(photo.first?.id ?? "")_\(photo.first?.secret ?? "")_b.jpg".lowercased()
        loadPhotoFromURL(with: flickerPhotoEndpoint, imageView: plantImageView)
    }
    @IBAction func birdButtonPressed(_ sender: UIButton) {
        if let imageZoomVC = UIStoryboard(name: "ImageZoomViewController", bundle: nil).instantiateViewController(identifier: "ImageZoomViewController") as? ImageZoomViewController {
            imageZoomVC.imageData = flickerBirdImageData
            imageZoomVC.zoomImage = birdImage
            imageZoomVC.nameForPhoto = duo?.birdCommonName ?? "Bird"
            if let navigator = navigationController {
                navigator.navigationController?.navigationBar.prefersLargeTitles = false
                navigator.navigationController?.navigationBar.topItem?.title = duo?.birdCommonName ?? "Bird"
                navigator.pushViewController(imageZoomVC, animated: true)
            }
        }
    }
    @IBAction func plantButtonPressed(_ sender: UIButton) {
        if let imageZoomVC = UIStoryboard(name: "ImageZoomViewController", bundle: nil).instantiateViewController(identifier: "ImageZoomViewController") as? ImageZoomViewController {
            imageZoomVC.imageData = flickerPlantImageData
            imageZoomVC.zoomImage = plantImage
            imageZoomVC.nameForPhoto = duo?.plantName ?? "Plant"
            
            if let navigator = navigationController {
                navigator.navigationController?.navigationBar.prefersLargeTitles = false
                navigator.navigationController?.navigationItem.title = duo?.plantName ?? "Plant"
                navigator.pushViewController(imageZoomVC, animated: true)
            }
        }
    }
    
}
//MARK:- Extensions

