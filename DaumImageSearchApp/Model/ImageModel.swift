//
//  ImageModel.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/10.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import Foundation

protocol ImageModelProtocol {
    func imagesRequested(images: [Image]?)
}

class ImageModel {
    
    var delegate: ImageModelProtocol?
    let decoder : JSONDecoder = JSONDecoder()
    
    init() {
        // 이미지 요청에 포함된 날짜 데이터를 저장하기 위한 데이터 포맷 설정.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        self.decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    /**
    다음 카카오 API에 이미지 1페이지 (30개) 요청.
    
    - Parameters:
        - query: 이미지 검색 키워드
        - page: 이미지 검색 페이지 번호 (페이지당 일정 개수 이미지 포함)
    - Returns: None
    */
    func requestImages(_ query: String, _ page: Int) {
        guard let delegate = self.delegate else {
            print("Delegate of ImageModel is nil.")
            return
        }
        
        // 검색어가 없을 경우, nil 전달.
        guard query != "" else {
            delegate.imagesRequested(images: nil)
            return
        }
        
        guard var urlComponents = URLComponents(string: "https://dapi.kakao.com/v2/search/image") else {
            print("URL is nil.")
            return
        }
        
        // 검색에, 이미지 개수, 페이지 번호 설정.
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "size", value: String(30)),
            URLQueryItem(name: "page", value: String(page))
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        // 카카오 API 키 설정.
        urlRequest.setValue("KakaoAK 344d4c75380cb7c9d0124dac1cf5e6df", forHTTPHeaderField: "Authorization")
        
        let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                print("Response Data is nil.")
                return
            }
            
            // 이미지를 성공적으로 받아서 디코딩 했을 경우, 뷰컨트롤러에 이미지 전달.
            do {
                let imageResponse: ImageResponse = try self.decoder.decode(ImageResponse.self, from: data)
                delegate.imagesRequested(images: imageResponse.images)
            }
            // 이미지 디코딩에 실패 했을 경우
            catch let DecodingError.dataCorrupted(context) {
                print(context)
                delegate.imagesRequested(images: nil)
            }
            catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                delegate.imagesRequested(images: nil)
            }
            catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                delegate.imagesRequested(images: nil)
            }
            catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                delegate.imagesRequested(images: nil)
            }
            catch {
                print("error: ", error)
                delegate.imagesRequested(images: nil)
            }
        }
        
        dataTask.resume()
    }
    
}
