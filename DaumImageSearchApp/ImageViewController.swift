//
//  ImageViewController.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/14.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    var selectedImage: Image? = nil
    var isFullScreen: Bool = false
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var selectedImageViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedImageViewConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var selectedImageInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedImage = self.selectedImage else { return }
        guard let imageURL: URL = URL(string: selectedImage.imageURL), let imageData: Data = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) else { return }
        DispatchQueue.main.async {
            let ratio = image.size.width / image.size.height
            let newHeight = self.selectedImageView.frame.width / ratio
            self.selectedImageViewConstraintHeight.constant = newHeight
            if self.view.frame.height > newHeight {
                self.selectedImageViewConstraintTop.constant = (self.view.frame.height - (newHeight + self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom)) / 2
            }
            self.view.layoutIfNeeded()
            
            self.selectedImageView.image = image
        }
        
        self.selectedImageInfoLabel.text = "\(selectedImage.displaySiteName) | \(selectedImage.dateTime.toString(dateFormat: "yyyy/MM/dd HH:mm:ss"))"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleFullScreen))
        view.addGestureRecognizer(tap)
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.isFullScreen
    }

    @objc func toggleFullScreen() {
        self.isFullScreen.toggle()
        if self.isFullScreen {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.selectedImageInfoLabel.isHidden = true
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.selectedImageInfoLabel.isHidden = false
        }
    }

}
