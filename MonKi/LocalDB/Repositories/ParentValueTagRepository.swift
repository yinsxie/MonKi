//
//  ParentValueTagRepository.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

import Foundation
import CoreData

protocol ParentValueTagRepositoryProtocol {
    func fetchAllParentValueTags() -> [ParentValueTag]
    
    func addParentValueTag(name: String)
    
    func updateParentValueTag(tag: ParentValueTag, newName: String)
    
    func deleteParentValueTag(tag: ParentValueTag)
    func deleteParentValueTagById(id: UUID)
    
}

final class ParentValueTagRepository: ParentValueTagRepositoryProtocol {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.viewContext) {
        self.context = context
    }
    
    func fetchAllParentValueTags() -> [ParentValueTag] {
        let fetchRequest: NSFetchRequest<ParentValueTag> = ParentValueTag.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func addParentValueTag(name: String) {
        let tag = ParentValueTag(context: context)
        tag.id = UUID()
        tag.valueTag = name
        tag.createdAt = Date()
        tag.updatedAt = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed to save ParentValueTag: \(error.localizedDescription)")
        }
    }
    
    func updateParentValueTag(tag: ParentValueTag, newName: String) {
        tag.valueTag = newName
        tag.updatedAt = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed to update ParentValueTag: \(error.localizedDescription)")
        }
    }
    
    func updateParentValueTagById(id: UUID, newName: String) {
        guard let tag = fetchParentValueTagById(id: id) else { return }
        updateParentValueTag(tag: tag, newName: newName)
    }
    
    func deleteParentValueTag(tag: ParentValueTag) {
        context.delete(tag)
        
        do {
            try context.save()
        } catch {
            print("Failed to delete ParentValueTag: \(error.localizedDescription)")
        }
    }
    
    func deleteParentValueTagById(id: UUID) {
        guard let tag = fetchParentValueTagById(id: id) else { return }
        deleteParentValueTag(tag: tag)
    }
    
}

private extension ParentValueTagRepository {
    func fetchParentValueTagById(id: UUID) -> ParentValueTag? {
        let fetchRequest: NSFetchRequest<ParentValueTag> = ParentValueTag.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            return nil
        }
    }
    
}
