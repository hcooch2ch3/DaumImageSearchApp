//
//  Image.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/10.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import Foundation

struct Image: Codable {
    let collection: String
    let thumbnailURL: String
    let imageURL: String
    let width: Int
    let height: Int
    let displaySiteName: String
    let docURL: String
    let dateTime: String
    
    enum CodingKeys: String, CodingKey {
        case collection, width, height
        case thumbnailURL = "thumbnail_url"
        case imageURL = "image_url"
        case displaySiteName = "display_sitename"
        case docURL = "doc_url"
        case dateTime = "datetime"
    }
}
