//
//  VersionsViewModel.swift
//  ShoeOsVersion
//
//  Created by Magnolia on 04.12.2017.
//  Copyright © 2017 Mangust. All rights reserved.
//

import UIKit

struct VersionsViewModel {
    
    // MARK: - Properties
    
    let title: String?
    let imageUrl: String?
    
    // MARK: - Initialization
    
    init(title: String? = nil, imageUrl: String? = nil) {
        self.title = title
        self.imageUrl = imageUrl
    }
    
//    var title: String {
//        return self.title!
//    }
//
//    var imageUrl: String {
//        return self.imageUrl!
//    }
    
}

