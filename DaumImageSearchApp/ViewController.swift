//
//  ViewController.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/10.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import UIKit

class ImageSearchViewController: UIViewController {
    
    // MARK:- Properties
    var images: [Image] = []
    var imageModel: ImageModel = ImageModel()
    let cellIdentifier: String = "imageCell"
    
    // MARK:- IBOutlets
    @IBOutlet weak var imageCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageModel.delegate = self
        self.imageModel.getImages("설현")
        
        self.setupNavigationBar()
        
    }
    
    func setupNavigationBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}

extension ImageSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
}

extension ImageSearchViewController: ImageModelProtocol {
    
    func imageRetrieved(images: [Image]) {
        self.images += images
    }
    
}

