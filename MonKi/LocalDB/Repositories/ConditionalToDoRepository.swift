//
//  ConditionalToDoRepository.swift
//  MonKi
//
//  Created by William on 06/11/25.
//
import Foundation
import CoreData

protocol ConditionalToDoRepositoryProtocol {
    func addBatchOfTodoToLog(forLogId id: UUID, list: [String])
    
    func updateCheckList(todos: [ConditionalToDo], withChecked checked: [Bool])
    
    func fetchOneLogTodos(forLogId logId: UUID) -> [ConditionalToDo]
    
    func deleteLogTodos(forLogId logId: UUID)
}

final class ConditionalToDoRepository: ConditionalToDoRepositoryProtocol {
    
    func addBatchOfTodoToLog(forLogId id: UUID, list: [String]) {
        for todo in list {
            let newTodo = ConditionalToDo(context: context)
            newTodo.id = UUID()
            newTodo.logId = id
            newTodo.title = todo
            newTodo.isChecked = false
            newTodo.createdAt = Date()
            newTodo.updatedAt = Date()
            
            do {
                try context.save()
            } catch {
                print("Failed to add new todo: \(error)")
            }
        }
    }
    
    func updateCheckList(todos: [ConditionalToDo], withChecked checked: [Bool]) {
        for (index, todo) in todos.enumerated() {
            todo.isChecked = checked[index]
            todo.updatedAt = Date()
        }
        do {
            try context.save()
        } catch {
            print("Failed to update checklist: \(error)")
        }
    }
    
    func fetchOneLogTodos(forLogId logId: UUID) -> [ConditionalToDo] {
        let fetchRequest: NSFetchRequest<ConditionalToDo> = ConditionalToDo.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func deleteLogTodos(forLogId logId: UUID) {
        let fetchRequest: NSFetchRequest<ConditionalToDo> = ConditionalToDo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "logId == %@", logId as CVarArg)
        
        do {
            let todosToDelete = try context.fetch(fetchRequest)
            for todo in todosToDelete {
                context.delete(todo)
            }
            try context.save()
        } catch {
            print("Failed to delete todos for logId \(logId): \(error)")
        }
    }
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataManager.shared.viewContext) {
        self.context = context
    }
}
