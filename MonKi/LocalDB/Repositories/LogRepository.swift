//
//  LogRepository.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

import CoreData
import UIKit

// logWaitingListToDo
// id
// logId
// title
// isChecked
// createdAt
// updatedAt

// predicate, where logid = logid

protocol LogRepositoryProtocol {
    func createLogOnly(_ uiImage: UIImage, happyLevel: Int, tags: [String])
    
    func logContinued(forLog log: MsLog, happyLevel: Int, tags: [String], withVerdict verdict: ParentLogVerdict)
    
    func createFullLog(_ uiImage: UIImage, happyLevel: Int, tags: [String], withVerdict verdict: ParentLogVerdict)
   
    func logHarvested(withId id: UUID)
    
    func logDeclined(withId id: UUID)
    
    func logDeletedAfterDeclined(withId id: UUID)
    func logDeletedAfterDeclined(withLog log: MsLog)
    
    func fetchLogs() -> [MsLog]
}

final class LogRepository: LogRepositoryProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.viewContext) {
        self.context = context
    }
    
    func logHarvested(withId id: UUID) {
        updateLogState(withId: id, newState: .logDone)
    }
    
    func logDeclined(withId id: UUID) {
        updateLogState(withId: id, newState: .logDeclined)
    }
    
    func logDeletedAfterDeclined(withId id: UUID) {
        guard let log = fetchLogById(id: id) else { return }
        deleteLog(log: log)
    }
    
    func logDeletedAfterDeclined(withLog log: MsLog) {
        deleteLog(log: log)
    }
    
    func createLogOnly(_ uiImage: UIImage, happyLevel: Int, tags: [String]) {
        guard let imagePath = ImageStorage.saveImage(uiImage) else {
            print("Failed to save image")
            return
        }
        
        createLog(imagePath: imagePath, withState: .logOnly, happyLevel: happyLevel, tags: tags, withVerdict: nil)
    }
    
    func logContinued(forLog log: MsLog, happyLevel: Int, tags: [String], withVerdict verdict: ParentLogVerdict) {
        
        log.happyLevel = Int16(happyLevel)
        log.beneficialTags = IOHelper.combineTag(tags)
        log.parentVerdict = verdict.value
        
        do {
            try context.save()
        } catch {
            print("Failed to update log state: \(error.localizedDescription)")
        }
    }
    
    func createFullLog(_ uiImage: UIImage, happyLevel: Int, tags: [String], withVerdict verdict: ParentLogVerdict) {
        guard let imagePath = ImageStorage.saveImage(uiImage) else {
            print("Failed to save image")
            return
        }
        
        var state: LogState = .logOnly
        switch verdict {
        case .approved:
            state = .logApproved
        case .conditional:
            state = .logWaiting
        case .declined:
            state = .logDeclined
        }
        
        createLog(imagePath: imagePath, withState: state, happyLevel: happyLevel, tags: tags, withVerdict: verdict)
    }
    
    func fetchLogs() -> [MsLog] {
        let fetchRequest: NSFetchRequest<MsLog> = MsLog.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
}

private extension LogRepository {
    
    func createLog(imagePath: String, withState state: LogState, happyLevel: Int, tags: [String], withVerdict verdict: ParentLogVerdict?) {
        let log = MsLog(context: context)
        
        log.id = UUID()
        log.beneficialTags = IOHelper.combineTag(tags)
        log.state = state.stringValue
        log.imagePath = imagePath
        log.createdAt = Date()
        log.updatedAt = Date()
        
        if let verdict = verdict?.value {
            log.parentVerdict = verdict
        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save log: \(error.localizedDescription)")
        }
    }
    
    func updateLogState(withId id: UUID, newState: LogState) {
        
        guard let log = fetchLogById(id: id) else {
            return
        }
        
        log.state = newState.stringValue
        log.updatedAt = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed to update log state: \(error.localizedDescription)")
        }
    }
    
    func fetchLogById(id: UUID) -> MsLog? {
        let fetchRequest: NSFetchRequest<MsLog> = MsLog.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch log by id: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    func deleteLog(log: MsLog) {
        context.delete(log)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete log: \(error.localizedDescription)")
        }
    }

}
