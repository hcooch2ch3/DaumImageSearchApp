//
//  Date+toString.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/14.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import Foundation

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter.string(from: self)
    }
}
