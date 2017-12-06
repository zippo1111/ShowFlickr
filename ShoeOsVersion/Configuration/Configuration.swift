//
//  Configuration.swift
//  ShoeOsVersion
//
//  Created by Magnolia on 04.12.2017.
//  Copyright © 2017 Mangust. All rights reserved.
//

import Foundation

struct API {
    
    static let BaseURL = URL(string: "https://api.flickr.com/services/rest/")
    
//    static let BaseURL = URL(string: "http://private-db05-jsontest111.apiary-mock.com/androids")
    
    // https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3cce73b0bdba02b2b641549488553bca&text=grizzly&per_page=20&format=json&nojsoncallback=1
    
    static var AuthenticatedBaseURL: URL {
        return BaseURL!
    }
    
}
