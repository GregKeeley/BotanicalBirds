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
    
    var zoomImage = UIImage(systemName: "photo.fill") {
        didSet {
            DispatchQueue.main.async {
                self.imageView.kf.indicatorType = .activity
                self.imageView.image = self.zoomImage
            }
        }
    }
    
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
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let zoomImage = zoomImage {
            setMinZoomScaleForImageSize(zoomImage.size)
        }
    }
    private func setupUI() {
        let flickerEndPoint = "https://farm\(imageData?.photos.photo.first?.farm ?? 0).staticflickr.com/\(imageData?.photos.photo.first?.server ?? "")/\(imageData?.photos.photo.first?.id ?? "")_\(imageData?.photos.photo.first?.secret ?? "")_b.jpg".lowercased()
        downloadImage(from: (URL(string: flickerEndPoint) ?? URL(string: "https://i.kym-cdn.com/photos/images/original/000/839/182/45a.gif"))!)
    }
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    private func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { [weak self] in
                self?.zoomImage = UIImage(data: data)
            }
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
//        if imageView.frame.height <= scrollView.frame.height {
//            let shiftHeight = scrollView.frame.height/2.0 - scrollView.contentSize.height/2.0
//            scrollView.contentInset.top = shiftHeight
//        }
//        if imageView.frame.width <= scrollView.frame.width {
//            let shiftWidth = scrollView.frame.width/2.0 - scrollView.contentSize.width/2.0
//            scrollView.contentInset.left = shiftWidth
//        } else {
//            scrollView.contentInset.top = 0
//        }
    }
}


