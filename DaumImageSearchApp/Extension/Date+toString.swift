//
//  Date+toString.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/14.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import Foundation

extension Date {
    
    /**
    입력되는 날짜 형식에 맞게 날짜 문자열을 리턴.
    
    - Parameters: 날짜 형식 'String'
    - Returns: 날짜 'String'
    */
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        
        // 사용자의 현재 타임존. 사용자의 타임존에 맞게 시간 나타내기 위함.
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        
        return dateFormatter.string(from: self)
    }
}
