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

    @IBOutlet weak var scrollView: ImageZoomView!
    
    var image: UIImage?
    
    var imageData: FlickerSearchResult? {
        didSet {
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    private func setupUI() {
        let flickerEndPoint = "https://farm\(imageData?.photos.photo.first?.farm ?? 0).staticflickr.com/\(imageData?.photos.photo.first?.server ?? "")/\(imageData?.photos.photo.first?.id ?? "")_\(imageData?.photos.photo.first?.secret ?? "")_o.jpg".lowercased()
//        scrollView.imageView.kf.setImage(with: URL(string: flickerEndPoint))
        scrollView.imageView.kf.setImage(with: URL(string: flickerEndPoint))
    }
}
