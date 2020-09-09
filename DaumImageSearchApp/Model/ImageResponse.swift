//
//  ImageResponseModel.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/10.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import Foundation

struct ImageResponse: Codable {
    let images: [Image]
    
    enum CodingKeys: String, CodingKey {
        case images = "documents"
    }
}
