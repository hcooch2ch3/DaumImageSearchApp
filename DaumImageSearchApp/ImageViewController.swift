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
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var displaySiteNameLabel: UILabel!
    @IBOutlet weak var imageInfoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedImage = self.selectedImage else { return }
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: selectedImage.imageURL) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
            guard let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                self.selectedImageView.image = image
                
                let zoomScale = self.selectedImageView.bounds.size.width / self.selectedImageView.contentClippingRect.width
                if zoomScale > 1 {
                    self.scrollView.maximumZoomScale = zoomScale + 2
                    self.scrollView.zoomScale = zoomScale
                    self.scrollView.setContentOffset(CGPoint(x: (self.scrollView.contentSize.width - self.scrollView.frame.size.width) / 2, y: 0), animated: false)
                }
            }
        }
        
        displaySiteNameLabel.text = selectedImage.displaySiteName
        dateTimeLabel.text = selectedImage.dateTime.toString(dateFormat: "yyyy/MM/dd HH:mm:ss")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleFullScreen))
        view.addGestureRecognizer(tap)
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.isFullScreen
    }
    
    @objc func toggleFullScreen() {
        if self.isFullScreen {
            self.isFullScreen = false
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.imageInfoView.isHidden = false
            self.selectedImageView.backgroundColor = UIColor.white
        } else {
            self.isFullScreen = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.imageInfoView.isHidden = true
            self.selectedImageView.backgroundColor = UIColor.black
        }
    }

}

extension ImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.selectedImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if self.isFullScreen == false {
            self.isFullScreen = true
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.imageInfoView.isHidden = true
            self.selectedImageView.backgroundColor = UIColor.black
        }
    }
    
}
