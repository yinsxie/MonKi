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
//            self.seedInitialData(context: self.viewContext)
        }
    }
    
    func save(context: NSManagedObjectContext? = nil) {
            let ctx = context ?? viewContext
            if ctx.hasChanges {
                try? ctx.save()
            }
        }
    
    // Seeder for parent home view
    private func seedInitialData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<MsLog> = MsLog.fetchRequest()
        
        do {
            let count = try context.count(for: fetchRequest)
            guard count == 0 else {
                print("Database already seeded. Skipping.")
                return
            }
        } catch {
            print("Failed to fetch log count: \(error.localizedDescription)")
            return
        }

        print("Seeding initial data...")
        
        // Initial Image, same across all logs
        guard let img = UIImage(named: "icecream_placeholder") else {
            return
        }
        let imagePath = ImageStorage.saveImage(img)

        // Log 1: Needs Review (state = "created")
        let log1 = MsLog(context: context)
        log1.id = UUID()
        log1.imagePath = imagePath
        log1.isHappy = true
        log1.isBeneficial = true
        log1.beneficialTags = "snack;sweet" // Your IOHelper combines tags
        log1.state = ChildrenLogState.created.stringValue
        log1.createdAt = Date()
        log1.updatedAt = Date()

        // Log 2: Needs Review (state = "created")
        let log2 = MsLog(context: context)
        log2.id = UUID()
        log2.imagePath = imagePath
        log2.isHappy = true
        log2.isBeneficial = false
        log2.beneficialTags = "toy;expensive"
        log2.state = ChildrenLogState.done.stringValue
        log2.createdAt = Date()
        log2.updatedAt = Date()
        
        // Log 3: Already Approved (state = "approved")
        let log3 = MsLog(context: context)
        log3.id = UUID()
        log3.imagePath = imagePath
        log3.isHappy = false
        log3.isBeneficial = true
        log3.beneficialTags = "book;education"
        log3.state = ChildrenLogState.declined.stringValue
        log3.createdAt = Date()
        log3.updatedAt = Date()
        
        let log4 = MsLog(context: context)
        log4.id = UUID()
        log4.imagePath = "icecream_placeholder"
        log4.isHappy = false
        log4.isBeneficial = true
        log4.beneficialTags = "book;education"
        log4.state = ChildrenLogState.approved.stringValue
        log4.createdAt = Date()
        log4.updatedAt = Date()

        // 3. Save the new data to the database
        do {
            try context.save()
            print("Initial data seeded successfully.")
        } catch {
            print("Failed to save seed data: \(error.localizedDescription)")
        }
        
        UserDefaultsManager.shared.incrementCurrentFilledField(by: 4)
    }
}
