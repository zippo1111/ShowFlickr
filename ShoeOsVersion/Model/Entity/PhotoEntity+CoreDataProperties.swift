//
//  PhotoEntity+CoreDataProperties.swift
//  
//
//  Created by Magnolia on 06.12.2017.
//
//

import Foundation
import CoreData


extension PhotoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoEntity> {
        return NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
    }

    @NSManaged public var photoName: String?
    @NSManaged public var photoUrl: String?

}
