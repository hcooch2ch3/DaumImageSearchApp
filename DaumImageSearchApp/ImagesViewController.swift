//
//  ViewController.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/10.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {
    
    // MARK:- Properties
    var images: [Image] = []
    var imageModel: ImageModel = ImageModel()
    let cellIdentifier: String = "ImagesCell"
    var lastSearchText: String = ""
    var page: Int = 1
    
    // MARK:- IBOutlets
    @IBOutlet weak var imagesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageModel.delegate = self
        self.imagesCollectionView.collectionViewLayout = flowLayout()
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}

extension ImagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImagesCollectionViewCell else {
            return ImagesCollectionViewCell()
        }
        
        let image = self.images[indexPath.row]
        
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: image.thumbnailURL) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
            guard let thumbnailImage = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                cell.thumbnailImageView.image = thumbnailImage
            }
        }
        
        return cell
    }
        
}

extension ImagesViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.text = lastSearchText
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        lastSearchText = searchText
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { timer in
            if self.lastSearchText == searchText {
                self.images.removeAll()
                if searchText == "" {
                    self.imagesCollectionView.reloadData()
                } else {
                    self.page = 1
                    self.imageModel.requestImages(searchText, self.page)
                }
            }
        })
    }
    
}

extension ImagesViewController {
    
    func flowLayout() -> UICollectionViewFlowLayout {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.minimumLineSpacing = 3
        
        let itemSpacing: CGFloat = 3
        let itemInOneLine: CGFloat = 3
        var deviceWidth: CGFloat = 0
        
        if UIDevice.current.orientation == .unknown {
            deviceWidth = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
        } else if UIDevice.current.orientation.isLandscape {
            deviceWidth = UIScreen.main.bounds.size.height
        } else {
            deviceWidth = UIScreen.main.bounds.size.width
        }
        
        let length = floor((deviceWidth - itemSpacing * CGFloat(itemInOneLine - 1))/itemInOneLine)
        flowLayout.itemSize = CGSize(width: length, height: length)
        
        return flowLayout
    }
    
}

extension ImagesViewController: ImageModelProtocol {
    
    func imagesRetrieved(images: [Image]?) {
        if let newImages = images {
            self.images += newImages
        }
        self.imagesCollectionView.reloadData()
    }
    
}

