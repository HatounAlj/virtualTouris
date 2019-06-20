//
//  Photo+CoreDataProperties.swift
//  Touris
//
//  Created by Eng.Hatoun 👩🏻‍💻 on 15/10/1440 AH.
//  Copyright © 1440 Eng.Hatoun 👩🏻‍💻. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var image: NSData?
    @NSManaged public var url: URL?
    @NSManaged public var pin: Pin?

}
