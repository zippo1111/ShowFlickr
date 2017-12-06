//
//  DataManager.swift
//  ShoeOsVersion
//
//  Created by Magnolia on 04.12.2017.
//  Copyright © 2017 Mangust. All rights reserved.
//

import Foundation

import SwiftyJSON

enum DataManagerError: Error {
    
    case unknown
    case failedRequest
    case invalidResponse
    
}

final class DataManager {
    
    typealias OperationCompletion = (ApiResponse?, DataManagerError?) -> ()
    
    // MARK: - Properties
    
    private let baseURL: URL
    
    // MARK: - Initialization
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // MARK: - Requesting Data
    
    func operationForWord(word: String, completion: @escaping OperationCompletion) {
        // Create URL
        
        var URL = baseURL
        
        var urlComponents = URLComponents(url: URL, resolvingAgainstBaseURL: false)
        
        let appendQuery: String = (word.count > 1) ? "text=\(word)&method=flickr.photos.search" : "method=flickr.photos.getRecent"
            
        urlComponents?.query =  "api_key=3cce73b0bdba02b2b641549488553bca&per_page=20&format=json&nojsoncallback=1&\(appendQuery)"
        
        URL = (urlComponents?.url!)!
        
        print("baseUrl:", baseURL)
        print("url: ", URL)
        
        
        DispatchQueue.global(qos: .background).async {

        // Create Data Task
            URLSession.shared.dataTask(with: URL) { (data, response, error) in
                
                DispatchQueue.main.async {
                    self.didFetchData(data: data, response: response, error: error, completion: completion)
                }
                
            }.resume()

        }
    }
    
    // MARK: - Helper Methods
    
    private func didFetchData(data: Data?, response: URLResponse?, error: Error?, completion: OperationCompletion) {
        if let _ = error {
            completion(nil, .failedRequest)
            
        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    // Decode JSON
                    let jsonObj = try! JSON(data: data)
                    let yandexData = try ApiResponse(json: jsonObj)
                    
                    // Invoke Completion Handler
                    completion(yandexData, nil)
                    
                } catch {
                    // Invoke Completion Handler
                    completion(nil, .invalidResponse)
                }
                
            } else {
                completion(nil, .failedRequest)
            }
            
        } else {
            completion(nil, .unknown)
        }
    }
    
}
