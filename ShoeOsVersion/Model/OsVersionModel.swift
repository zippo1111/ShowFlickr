//
//  OsVersionModel.swift
//  ShoeOsVersion
//
//  Created by Magnolia on 04.12.2017.
//  Copyright © 2017 Mangust. All rights reserved.
//

import Foundation

struct OsVersionModel {
    
    fileprivate enum Keys {
        
        static let title = "title"
        static let imageUrl = "imageUrl"
        
    }
    
    // MARK: - Properties
    
    let title: String
    let imageUrl: String
    
    var asDictionary: [String: Any] {
        return [ Keys.title: title,
                 Keys.imageUrl : imageUrl ]
    }
    
}

extension OsVersionModel {
    
    // MARK: - Initialization
    
    init?(dictionary: [String: Any]) {
        
        guard let title = dictionary[Keys.title] as? String else { return nil }
        guard let imageUrl = dictionary[Keys.imageUrl] as? String else { return nil }
        
        self.title = title
        self.imageUrl = imageUrl
    }
    
}

extension OsVersionModel: Equatable {
    
    static func ==(lhs: OsVersionModel, rhs: OsVersionModel) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.imageUrl == rhs.imageUrl
    }
    
}
