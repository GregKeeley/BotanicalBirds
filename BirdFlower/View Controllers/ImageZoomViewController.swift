//
//  ImageZoomViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 9/8/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import Kingfisher

class ImageZoomViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageData: FlickerSearchResult?
    
    var nameForPhoto = "" {
        didSet {
            navigationItem.title = nameForPhoto
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupUI() {
        let flickerEndPoint = "https://farm\(imageData?.photos.photo.first?.farm ?? 0).staticflickr.com/\(imageData?.photos.photo.first?.server ?? "")/\(imageData?.photos.photo.first?.id ?? "")_\(imageData?.photos.photo.first?.secret ?? "")_b.jpg".lowercased()
        DispatchQueue.main.async {
            self.imageView.kf.indicatorType = .activity
            self.imageView.kf.setImage(with: URL(string: flickerEndPoint))
        }
    }
}
extension ImageZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if imageView.frame.height <= scrollView.frame.height {
            let shiftHeight = scrollView.frame.height/2.0 - scrollView.contentSize.height/2.0
            scrollView.contentInset.top = shiftHeight
        }
        if imageView.frame.width <= scrollView.frame.width {
            let shiftWidth = scrollView.frame.width/2.0 - scrollView.contentSize.width/2.0
            scrollView.contentInset.left = shiftWidth
        } else {
            scrollView.contentInset.top = 0
        }
    }
}


