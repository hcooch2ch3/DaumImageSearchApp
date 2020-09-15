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
    let cellIdentifier: String = "ImagesCell"
    var lastSearchText: String = ""
    var page: Int = 1
    
    // MARK:- IBOutlets
    @IBOutlet weak var imagesCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageModel.delegate = self
        self.imagesCollectionView.collectionViewLayout = flowLayout()
        self.imagesCollectionView.prefetchDataSource = self
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imageViewController: ImageViewController = segue.destination as? ImageViewController else { return }
        guard let cell: ImagesCollectionViewCell = sender as? ImagesCollectionViewCell else { return }
        guard let indexPath = imagesCollectionView.indexPath(for: cell) else { return }
        let image = self.images[indexPath.row]
        
        imageViewController.selectedImage = image
    }
    
}

extension ImageSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.images.count == 0 {
            if self.lastSearchText == "" {
                collectionView.showEmptyMessage("검색어를 입력하세요.")
            } else {
                collectionView.showEmptyMessage("검색결과가 없습니다.")
            }
        } else {
            collectionView.dismissEmptyMessage()
        }
        
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImagesCollectionViewCell else {
            return ImagesCollectionViewCell()
        }
        
        let image = self.images[indexPath.row]
        
        DispatchQueue.main.async {
            guard let imageURL: URL = URL(string: image.thumbnailURL) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
            guard let thumbnailImage = UIImage(data: imageData) else { return }
        
            cell.thumbnailImageView.image = thumbnailImage
        }
        
        return cell
    }
        
}

extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let upcomingRows = indexPaths.map { $0.row }
        if let maxIndex = upcomingRows.max(), maxIndex > (self.page * 30) - 5 {
            self.page += 1
            self.imageModel.requestImages(self.lastSearchText, self.page)
        }
    }
    
}

extension ImageSearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.text = lastSearchText
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.main.async {
            self.lastSearchText = searchText
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { timer in
                if self.lastSearchText == searchText {
                    self.images.removeAll()
                    self.page = 1
                    self.imageModel.requestImages(searchText, self.page)
                }
            })
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.searchController?.dismiss(animated: true, completion: nil)
    }
    
}

extension ImageSearchViewController {
    
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

extension ImageSearchViewController: ImageModelProtocol {
    
    func imagesRequested(images: [Image]?) {
        if let newImages = images {
            self.images += newImages
        }
        
        self.imagesCollectionView.reloadData()
        
        if images != nil && images!.count > 0 && self.page == 1 {
            self.imagesCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
}

