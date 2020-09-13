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
            navigationController?.navigationBar.barStyle = UIBarStyle.black
            navigationController?.navigationBar.tintColor = UIColor.white
            navigationItem.title = nameForPhoto
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationController?.navigationBar.prefersLargeTitles = false
        scrollView.delegate = self
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navigationController?.navigationBar.tintColor = .clear
    }
    override func viewDidDisappear(_ animated: Bool) {
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    private func setupUI() {
        let flickerEndPoint = "https://farm\(imageData?.photos.photo.first?.farm ?? 0).staticflickr.com/\(imageData?.photos.photo.first?.server ?? "")/\(imageData?.photos.photo.first?.id ?? "")_\(imageData?.photos.photo.first?.secret ?? "")_b.jpg".lowercased()
        print(flickerEndPoint)
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


