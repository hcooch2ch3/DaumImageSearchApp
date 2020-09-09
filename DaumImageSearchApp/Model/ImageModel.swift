//
//  ImageModel.swift
//  DaumImageSearchApp
//
//  Created by 임성민 on 2020/09/10.
//  Copyright © 2020 SeongMin. All rights reserved.
//

import Foundation

protocol ImageModelProtocol {
    func imageRetrieved(images: [Image])
}

class ImageModel {
    
    var delegate: ImageModelProtocol?
    
    func getImages(_ query: String) {
        guard let delegate = self.delegate else {
            print("Delegate of ImageModel is nil.")
            return
        }
        
        guard var urlComponents = URLComponents(string: "https://dapi.kakao.com/v2/search/image") else {
            print("URL is nil.")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        
        guard let url = urlComponents.url else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
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
            
            do {
                let imageResponse: ImageResponse = try JSONDecoder().decode(ImageResponse.self, from: data)
                DispatchQueue.main.async {
                    delegate.imageRetrieved(images: imageResponse.images)
                }
            }
            catch {
                
            }
        }
        
        dataTask.resume()
    }
    
}