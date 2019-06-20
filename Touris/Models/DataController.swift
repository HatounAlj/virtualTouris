//
//  File.swift
//  Touris
//
//  Created by Eng.Hatoun 👩🏻‍💻 on 12/10/1440 AH.
//  Copyright © 1440 Eng.Hatoun 👩🏻‍💻. All rights reserved.
//

import Foundation
import CoreData

class DataController {
static let sharedInstance = DataController()
    let persistentcontainter = NSPersistentContainer(name: "Model")
    var viewContext:NSManagedObjectContext{
        return persistentcontainter.viewContext
    }

    func load(){
        persistentcontainter.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }        }
    }
}
