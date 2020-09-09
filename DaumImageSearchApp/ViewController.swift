//
//  ViewController.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/10.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var images: [Image] = []
    var imageModel: ImageModel = ImageModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageModel.delegate = self
        self.imageModel.getImages("설현")
        
    }

}

extension ViewController: ImageModelProtocol {
    
    func imageRetrieved(images: [Image]) {
        self.images += images
    }
    
}

