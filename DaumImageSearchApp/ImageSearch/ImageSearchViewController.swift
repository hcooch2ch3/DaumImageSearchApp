//
//  ViewController.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/10.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import UIKit

class ImageSearchViewController: UIViewController {
    // MARK: Properties
    
    var images: [Image] = []
    
    /// 이미지 요청 기능을 수행하는 이미지 모델.
    var imageModel: ImageModel = ImageModel()
    
    let cellIdentifier: String = "ImagesCell"
    
    /// 검색창에 입력된 검색어 중 가장 최근 검색어.
    var lastSearchText: String = ""
    
    /// 현재 보여주고 있는 이미지들의 페이지 번호.
    var page: Int = 1
    
    // MARK: IBOutlets
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!

    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageModel.delegate = self
        self.imagesCollectionView.collectionViewLayout = flowLayout()
        self.imagesCollectionView.prefetchDataSource = self
        self.setupNavigationBar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imageViewController: ImageViewController = segue.destination as? ImageViewController else { return }
        guard let cell: ImagesCollectionViewCell = sender as? ImagesCollectionViewCell, let indexPath = imagesCollectionView.indexPath(for: cell) else { return }
        
        let image = self.images[indexPath.row]
        
        imageViewController.selectedImage = image
    }
    
}

extension ImageSearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.images.count == 0 {
            // 검색어가 없을 경우, 검색어 입력 요청 메세지 표시
            if self.lastSearchText == "" {
                collectionView.showEmptyMessage("검색어를 입력하세요.")
            // 검색 결과가 없을 경우
            } else {
                collectionView.showEmptyMessage("검색결과가 없습니다.")
            }
        } else {
            // 이미지가 있을 경우, 안내 메세지 삭제
            collectionView.dismissEmptyMessage()
        }
        
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ImagesCollectionViewCell else { return ImagesCollectionViewCell() }
        // 셀 테그에 이미지 순서 대입(셀 재사용 및 비동기 이미지 로드로 인한 셀 이미지 오배치 방지 목적).
        cell.tag = indexPath.row
        let image = self.images[indexPath.row]
        
        DispatchQueue.global().async {
            guard let imageURL: URL = URL(string: image.thumbnailURL) else { return }
            guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
            DispatchQueue.main.async {
                // 셀 테그와 이미지 순서가 같을 경우만 이미지 삽입.
                if cell.tag == indexPath.row {
                    cell.thumbnailImageView.image = UIImage(data: imageData)
                }
            }
        }
        
        
        return cell
    }
        
}

extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // 스크롤 할 때, 바로 다음에 표시될 셀들의 인덱스
        let upcomingRows = indexPaths.map { $0.row }
        
        // 컬렉션 뷰를 아래로 스크롤 할 때, 받아온 이미지를 모두 표시하기 직전에 새로운 이미지를 요청.
        if let maxIndex = upcomingRows.max(), maxIndex > (self.page * 30) - 5 {
            // 페이지 추가, 페이지 1개당 30개 이미지 요청.
            self.page += 1
            // 최종 검색어와 최근 추가된 페이지를 토대로 이미지 요청.
            self.imageModel.requestImages(self.lastSearchText, self.page)
        }
    }
    
}

extension ImageSearchViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.text = lastSearchText
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 검색창의 문자가 변할때마다 최종 검색어 변수에 대입.
        self.lastSearchText = searchText
        // 검색창의 현재 검색어가 1초 이전의 최종 검색어와 같을 경우(검색어가 1초 이상 유지될 경우), 현재 검색어로 이미지 요청.
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { timer in
            if self.lastSearchText == searchText {
                // 이전에 추가된 이미지 삭제
                self.images.removeAll()
                // 페이지 초기화
                self.page = 1
                self.imageModel.requestImages(searchText, self.page)
            }
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 키보드 검색버튼 입력시 검색창 숨기기.
        self.navigationItem.searchController?.dismiss(animated: true, completion: nil)
    }
    
}

extension ImageSearchViewController {
    
    /**
     컬렉션뷰가 다양한 기기와 기기 방향을 고려하여 이미지를 나타낼 수 있도록 하는 FlowLayout를 리턴.
     
     - Parameters: None
     - Returns: 현재 뷰컨트롤러에서 사용할 'UICollectionViewFlowLayout'
     */
    func flowLayout() -> UICollectionViewFlowLayout {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 3
        flowLayout.minimumLineSpacing = 3
        
        let itemSpacing: CGFloat = 3
        let itemInOneLine: CGFloat = 3
        var deviceWidth: CGFloat = 0
        
        // 기기의 현재 방향의 가로 길이를 대입
        if UIDevice.current.orientation == .unknown {
            deviceWidth = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? UIScreen.main.bounds.size.height : UIScreen.main.bounds.size.width
        } else if UIDevice.current.orientation.isLandscape {
            deviceWidth = UIScreen.main.bounds.size.height
        } else {
            deviceWidth = UIScreen.main.bounds.size.width
        }
        
        // 기기의 가로 길이와 셀 간격을 토대로 최종 셀 길이 산출
        let cellLength = floor((deviceWidth - itemSpacing * CGFloat(itemInOneLine - 1))/itemInOneLine)
        
        flowLayout.itemSize = CGSize(width: cellLength, height: cellLength)
        
        return flowLayout
    }
    
    /**
    뷰컨트롤러 네비게이션 바에 검색 창 추가 및 설정
    
    - Parameters: None
    - Returns: None
    */
    func setupNavigationBar() {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}

extension ImageSearchViewController: ImageModelProtocol {
    
    /**
    요청한 이미지를 현재 뷰 컨트롤러에 추가하고 컬렉션뷰 새로고침.
    이전 검색에 스크롤이 아래로 내려갔을수 있으므로 스크롤 최상단 이동.
    
    - Parameters: 요청한 이미지 '[Image]?'
    - Returns: None
    */
    func imagesRequested(images: [Image]?) {
        DispatchQueue.main.async {
            if let newImages = images {
                // 요청한 이미지를 기존의 이미지에 추가.
                self.images += newImages
            }
            
            self.imagesCollectionView.reloadData()
            
            // 새로운 검색일 경우, 스크롤을 최상단으로 이동.
            if images != nil && images!.count > 0 && self.page == 1 {
                self.imagesCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }
    }
    
}

