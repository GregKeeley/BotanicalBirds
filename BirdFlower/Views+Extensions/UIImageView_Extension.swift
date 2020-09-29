//
//  UIImageView_Extension.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 9/24/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
extension UIImageView {
    func getImage(with urlString: String,
                  completion: @escaping (Result<UIImage, AppError>) -> ()) {
        var activityIndicator: UIActivityIndicatorView?

        DispatchQueue.main.async {
            activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator?.startAnimating()
            activityIndicator?.center = self.center
            self.addSubview(activityIndicator!)
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL(urlString)))
            return
        }
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { [weak activityIndicator] (result) in
            DispatchQueue.main.async {
                activityIndicator?.stopAnimating()
            }
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(.success(image))
                }
            }
        }
    }
    
    func createShadows() -> UIImageView {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 1
        outerView.layer.shadowRadius = 3
        outerView.layer.shadowOffset = CGSize(width: 4, height: 4)
        outerView.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 8).cgPath
        let imageView = UIImageView(frame: outerView.bounds)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        outerView.addSubview(self)
        return imageView
    }
}
