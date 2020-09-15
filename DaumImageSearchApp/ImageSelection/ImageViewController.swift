//
//  ImageViewController.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/14.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    // MARK: Properties
    
    var selectedImage: Image? = nil
    
    /// 현재 이미지 풀스크린(단독 보기) 여부
    var isFullScreen: Bool = false
    
    // MARK: IBOutlets
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var selectedImageViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedImageViewConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var selectedImageInfoLabel: UILabel!
    
    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let selectedImage = self.selectedImage else { return }
        guard let imageURL: URL = URL(string: selectedImage.imageURL), let imageData: Data = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) else { return }
        
        // 이미지를 기기의 가로 방향에 맞게 꽉 채우고, 기기의 세로 방향보다 길면 스크롤해서 볼 수 있도록 사이즈 조절.
        DispatchQueue.main.async {
            // 이미지 길이 너비 비율 산출.
            let ratio = image.size.width / image.size.height
            // 이미지 길이 너비 비율에 맞는 이미지 길이(높이).
            let newHeight = self.selectedImageView.frame.width / ratio
            // 이미지 길이 변경.
            self.selectedImageViewConstraintHeight.constant = newHeight
            
            // 이미지 길이가 기기의 세로방향 보다 작으면 화면의 세로 중앙에 놓기 위함.
            if self.view.frame.height > newHeight {
                // 이미지를 중앙에 높기 위해 뷰의 최상단에서 일정 길이 뒤로 옮기기.
                self.selectedImageViewConstraintTop.constant = (self.view.frame.height - (newHeight + self.view.safeAreaInsets.top + self.view.safeAreaInsets.bottom)) / 2
            }
            
            self.view.layoutIfNeeded()
            
            self.selectedImageView.image = image
        }
        
        // 이미지 정보 (출처 | 작성시간) 표시.
        self.selectedImageInfoLabel.text = "\(selectedImage.displaySiteName) | \(selectedImage.dateTime.toString(dateFormat: "yyyy/MM/dd HH:mm:ss"))"
        
        // 이미지 풀스크린 보기 지원 위해 탭 제스쳐 초기화.
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleFullScreen))
        view.addGestureRecognizer(tap)
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.isFullScreen
    }
    
    /**
    선택한 이미지를 단독으로 볼 수 있도록 네비게이션 바와 사진 정보 숨김 또는 보임.
    
    - Parameters: None
    - Returns: None
    */
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
