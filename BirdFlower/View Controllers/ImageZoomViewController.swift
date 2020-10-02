//
//  ImageZoomViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 9/8/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import Kingfisher
import DataPersistence

class ImageZoomViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    
    // TODO: Encapsulate objects Mark variables private (review class notes, OOP, GCD, inheritance, encapsulation, polymorphism, protocol oriented programming vs OOP, protocol vs methods)
    var imageData: FlickerSearchResult?
    
    var zoomImage: UIImage?
    
    var currentItem: FavoriteDuo?
    var favorites: [FavoriteDuo]?
    var isFavorite = false
    var bird: BirdsSpecies? {
        didSet {
            currentItem = FavoriteDuo(birdCommonName: bird?.commonName ?? "Bird", birdScientificName: bird?.scientificName ?? "Scientific name", plantName: "")
        }
    }
    var plant: PlantsSpecies? {
        didSet {
            currentItem = FavoriteDuo(birdCommonName: "", birdScientificName: "", plantName: plant?.name ?? "Plant")
        }
    }
    
    
    var nameForPhoto = "" {
        didSet {
            navigationItem.title = nameForPhoto
        }
    }
    
    public var dataPersistence: DataPersistence<FavoriteDuo>?
    
    init(_ image: UIImage, persistence: DataPersistence<FavoriteDuo>) {
        super.init(nibName: nil, bundle: nil)
        zoomImage = image
        dataPersistence = persistence
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2
        scrollView.minimumZoomScale = 1
        fetchFavoriteDuos()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        setupUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let zoomImage = zoomImage {
            setMinZoomScaleForImageSize(zoomImage.size)
        }
    }
    
    
    private func setupUI() {
        self.tabBarController?.tabBar.isHidden = true
        DispatchQueue.main.async {
            self.imageView.image = self.zoomImage
        }
        guard let itemToBeSaved = currentItem else {
            return
        }
        if (self.dataPersistence?.hasItemBeenSaved(itemToBeSaved) ?? true) {
            isFavorite = true
            favoriteButton.image = UIImage(systemName: "heart.fill")
            favoriteButton.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
    }
    private func fetchFavoriteDuos() {
        do {
            favorites = try dataPersistence?.loadItems()
        } catch {
            print("Failed to load favorites")
        }
    }
    private func setMinZoomScaleForImageSize(_ imageSize: CGSize) {
        let widthScale = view.frame.width / imageSize.width
        let heightScale = view.frame.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        // Scale the image down to fit in the view
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        
        // Set the image frame size after scaling down
        let imageWidth = imageSize.width * minScale
        let imageHeight = imageSize.height * minScale
        let newImageFrame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
        imageView.frame = newImageFrame
        centerImage()
    }
    private func centerImage() {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = view.frame.size
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    private func zoomRectangle(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        zoomRect.origin.x = center.x - (center.x * scrollView.zoomScale)
        zoomRect.origin.y = center.y - (center.y * scrollView.zoomScale)
        return zoomRect
    }
    private func setupDataPersistence() {
        if let tabBarController = self.tabBarController as? MainTabBarController {
            dataPersistence = tabBarController.dataPersistence
        }
    }
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        var itemToBeSaved = FavoriteDuo(birdCommonName: "", birdScientificName: "", plantName: "")
//        guard bird != nil, plant != nil else {
//            showAlert(title: "Something went wrong", message: "How are both bird and plant empty?")
//            return
//        }
        if isFavorite == false {
            if bird != nil {
                itemToBeSaved = FavoriteDuo(birdCommonName: bird?.commonName ?? "Bird", birdScientificName: bird?.scientificName ?? "Scientific name", plantName: "")
            } else if plant != nil {
                itemToBeSaved = FavoriteDuo(birdCommonName: "", birdScientificName: "", plantName: plant?.name ?? "Plant")
            }
            if !(self.dataPersistence?.hasItemBeenSaved(itemToBeSaved) ?? false) {
                do {
                    try self.dataPersistence?.createItem(itemToBeSaved)
                    favoriteButton.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                    favoriteButton.image = UIImage(systemName: "heart.fill")
                    isFavorite = true
                    fetchFavoriteDuos()
                } catch {
                    print("Failed to save")
                }
            } else if (self.dataPersistence?.hasItemBeenSaved(itemToBeSaved) ?? true) {
                showAlert(title: "This has already been saved", message: "No need to save it!")
            }
        } else if isFavorite == true {
            guard let favoriteIndex = self.favorites?.firstIndex(of: currentItem! ) else {
                return
            }
            do {
                try self.dataPersistence?.deleteItem(at: favoriteIndex)
                isFavorite = false
                favoriteButton.image = UIImage(systemName: "heart")
                favoriteButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } catch {
                showAlert(title: "something went wrong", message: "I tried deleting your favorite")
            }
        }
    }
    @IBAction func doubleTapGesture(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            scrollView.zoom(to: zoomRectangle(scale: scrollView.maximumZoomScale, center: sender.location(in: sender.view)), animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
}

extension ImageZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
}


