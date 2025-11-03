//
//  LogRepository.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

import CoreData
import UIKit

protocol LogRepositoryProtocol {
    
    func createLogWithImage(_ uiImage: UIImage, isHappy: Bool, happyLevel: Int? ,isBeneficial: Bool, tags: [String])
    func fetchLogs() -> [MsLog]
    func childRelogged(withId id: UUID, isHappy: Bool, happyLevel: Int? , isBeneficial: Bool, tags: [String])
    
    func logApprovedByParent(withId id: UUID)
    func logRejectedByParent(withId id: UUID)
    func logDone(withId id: UUID)
    func logArchieved(withId id: UUID)
    func logReplaced(replacedLog log: MsLog, newImage: UIImage, isHappy: Bool, happyLevel: Int?, isBeneficial: Bool, tags: [String])
}

final class LogRepository: LogRepositoryProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.viewContext) {
        self.context = context
    }
    
    func createLogWithImage(_ uiImage: UIImage, isHappy: Bool,happyLevel: Int? , isBeneficial: Bool, tags: [String]) {
        
        guard let imagePath = ImageStorage.saveImage(uiImage) else {
            print("Failed to save image")
            return
        }
        
        createLog(imagePath: imagePath, isHappy: isHappy, happyLevel: happyLevel, isBeneficial: isBeneficial, tags: tags)
    }
    
    func fetchLogs() -> [MsLog] {
        let fetchRequest: NSFetchRequest<MsLog> = MsLog.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func childRelogged(withId id: UUID, isHappy: Bool, happyLevel: Int? , isBeneficial: Bool, tags: [String]) {
        guard let log = fetchLogById(id: id) else {
            return
        }
        
        log.isHappy = isHappy
        log.isBeneficial = isBeneficial
        log.beneficialTags = IOHelper.combineTag(tags)
        log.updatedAt = Date()
        
        do {
            try context.save()
            updateLogState(withId: id, newState: .created)
        } catch {
            print("Failed to update log state: \(error.localizedDescription)")
        }
    }
    
    func logApprovedByParent(withId id: UUID) {
        updateLogState(withId: id, newState: .approved)
    }
    
    func logRejectedByParent(withId id: UUID) {
        updateLogState(withId: id, newState: .declined)
    }
    
    func logDone(withId id: UUID) {
        updateLogState(withId: id, newState: .done)
    }
    
    func logArchieved(withId id: UUID) {
        updateLogState(withId: id, newState: .archived)
    }
    
    func logReplaced(replacedLog log: MsLog, newImage: UIImage, isHappy: Bool, happyLevel: Int?, isBeneficial: Bool, tags: [String]) {
        deleteLog(log: log)
        createLogWithImage(newImage, isHappy: isHappy,happyLevel: happyLevel ,isBeneficial: isBeneficial, tags: tags)
    }
}

private extension LogRepository {
    
    func createLog(imagePath: String, isHappy: Bool, happyLevel: Int?, isBeneficial: Bool, tags: [String]) {
        let log = MsLog(context: context)
        
        log.id = UUID()
        log.beneficialTags = IOHelper.combineTag(tags)
        log.isBeneficial = isBeneficial
        log.isHappy = isHappy
        log.happyLevel = Int16(happyLevel ?? 0)
        log.state = ChildrenLogState.created.stringValue
        log.imagePath = imagePath
        log.createdAt = Date()
        log.updatedAt = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed to save log: \(error.localizedDescription)")
        }
    }
    
    func updateLogState(withId id: UUID, newState: ChildrenLogState) {
        
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
