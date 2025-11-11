//
//  CoreDataManager.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager: ObservableObject {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init () {
        persistentContainer = NSPersistentContainer(name: "MonKi")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Core Data Failed \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext? = nil) {
            let ctx = context ?? viewContext
            if ctx.hasChanges {
                try? ctx.save()
            }
        }
    
    // Seeder for parent home view
}
