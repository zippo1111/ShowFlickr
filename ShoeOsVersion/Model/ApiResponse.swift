//
//  ApiResponse.swift
//  ShoeOsVersion
//
//  Created by Magnolia on 04.12.2017.
//  Copyright © 2017 Mangust. All rights reserved.
//

import Foundation
import SwiftyJSON

class ApiResponse {
    
    var photosModel: [Photo]
    //var osVersions: [OsVersionModel]
    
    init(json: JSON) throws {
        
        guard let photos = json["photos"]["photo"].array else {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Parsing JSON not valid."])
        }
        
        photosModel = photos.map({ Photo(json:$0)})
        
    }
    
    
}



