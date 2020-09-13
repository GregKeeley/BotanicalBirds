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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
        scrollView.delegate = self
//        let normalScale = scrollView.bounds.width / imageView.bounds.width
        scrollView.maximumZoomScale = 4
        scrollView.minimumZoomScale = 1
//        scrollView.bouncesZoom = true
        //        scrollView.contentSize = imageView.frame.size
//        scrollView.zoomScale = normalScale
        
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


