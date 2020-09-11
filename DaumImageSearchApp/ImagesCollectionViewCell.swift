//
//  ImageCollectionViewCell.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/11.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.thumbnailImageView.image = nil
    }
    
}
