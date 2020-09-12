//
//  AboutViewController.swift
//  BirdFlower
//
//  Created by Gregory Keeley on 9/7/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import SafariServices

class AboutViewController: UIViewController {

    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var bkgdView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    private func setupUI() {
//        websiteButton.clearColorForTitle()
        websiteButton.sizeToFit()
        websiteButton.layer.cornerRadius = 4
        bkgdView.layer.cornerRadius = 4
        websiteButton.titleLabel?.text = "MeghanKeeley.com/botanicalbirds"
        websiteButton.titleLabel?.textAlignment = .center
        websiteButton.titleLabel?.adjustsFontSizeToFitWidth = true
        websiteButton.titleLabel?.baselineAdjustment = .alignCenters
        self.tabBarController?.tabBar.isHidden = true
    }
    @IBAction func websiteButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: "https://www.meghankeeley.com/botanicalbirds") else {
            showAlert(title: "Error", message: "Something went wrong with safari link")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}


//MARK:- UIButton Extension TODO: Move this to an extension file
extension UIButton {
    func clearColorForTitle() {
        let buttonSize = bounds.size
        if let font = titleLabel?.font{
            let attribs = [NSAttributedString.Key.font: font]
            if let textSize = titleLabel?.text?.size(withAttributes: attribs) {
                UIGraphicsBeginImageContextWithOptions(buttonSize, false, UIScreen.main.scale)
                if let ctx = UIGraphicsGetCurrentContext(){
                    ctx.setFillColor(UIColor.white.cgColor)
                    
                    let center = CGPoint(x: buttonSize.width / 2 - textSize.width / 2, y: buttonSize.height / 2 - textSize.height / 2)
                    let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: buttonSize.width, height: buttonSize.height))
                    ctx.addPath(path.cgPath)
                    ctx.fillPath()
                    ctx.setBlendMode(.destinationOut)
                    titleLabel?.text?.draw(at: center, withAttributes: [NSAttributedString.Key.font: font])
                    if let viewImage = UIGraphicsGetImageFromCurrentImageContext() {
                        UIGraphicsEndImageContext()
                        let maskLayer = CALayer()
                        maskLayer.contents = ((viewImage.cgImage) as AnyObject)
                        maskLayer.frame = bounds
                        layer.mask = maskLayer
                    }
                }
            }
        }
    }
}
