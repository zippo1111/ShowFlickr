//
//  Photo.swift
//  ShoeOsVersion
//
//  Created by Magnolia on 04.12.2017.
//  Copyright © 2017 Mangust. All rights reserved.
//

import Foundation

import SwiftyJSON

struct Photo {
    
    var title: String
    var imgUrl: String
    
    init(json: JSON) {
        
        self.title  = json["title"].stringValue
        /**
         https://farm5.staticflickr.com/
         4532/23929863497_a673ab238c_m.jpg
         
         * size: "m" or "b"
         server/photoid_secret_size.jpg
        */
        let server: String = json["server"].stringValue
        let photoid: String = json["id"].stringValue
        let secret: String = json["secret"].stringValue
        
        self.imgUrl = "https://farm5.staticflickr.com/\(server)/\(photoid)_\(secret)_b.jpg"
        
        //self.imgUrl = json["img"].stringValue
        
    }
    
    init(title: String, imgurl: String) {
        
        self.title = title
        self.imgUrl = imgurl
        
    }
    
}
