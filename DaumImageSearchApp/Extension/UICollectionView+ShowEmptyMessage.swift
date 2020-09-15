//
//  UICollectionView+ShowEmptyMessage.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/12.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    /**
    컬렉션 뷰에 아무것도 없을 때 안내 메세지를 표시.
    
    - Parameters: 컬렉션 뷰에 표시할 안내 메세지 'String'
    - Returns: None
    */
    func showEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    /**
    컬렉션 뷰 안내 메세지 제거.
    
    - Parameters: None
    - Returns: None
    */
    func dismissEmptyMessage() {
        self.backgroundView = nil
    }
}
