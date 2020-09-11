//
//  UICollectionView+ShowEmptyMessage.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/12.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import UIKit

extension UICollectionView {
    
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

    func dismissEmptyMessage() {
        self.backgroundView = nil
    }
    
}
