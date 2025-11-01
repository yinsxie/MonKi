//
//  ParentValueTagViewModel.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 01/11/25.
//

import Foundation
import Combine

@MainActor
final class ParentValueTagViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// The list of individual tags for the UI (e.g., "Sehat", "Pintar").
    @Published var tags: [String] = []
    
    /// The text for the new tag input field.
    @Published var newTagText: String = ""
    
    /// The repository for database access.
    private let repo: ParentValueTagRepositoryProtocol
    
    /// A reference to the single Core Data object we are editing.
    private var parentTagObject: ParentValueTag?
    
    // MARK: - Initialization
    
    init(repo: ParentValueTagRepositoryProtocol = ParentValueTagRepository()) {
        self.repo = repo
        // We call loadTags() when the view appears, not in init,
        // to ensure it reloads if the user navigates away and comes back.
    }
    
    // MARK: - Core Functions
    
    /// Loads the tags from Core Data and populates the `tags` array.
    func loadTags() {
        // Fetch all tag objects (we assume there's only one).
        let tagObjects = repo.fetchAllParentValueTags()
        
        if let firstTagObject = tagObjects.first {
            // Store the object so we can update it later.
            self.parentTagObject = firstTagObject
            
            // Get the raw string (e.g., "Sehat;Pintar") and split it.
            let rawTags = firstTagObject.valueTag ?? ""
            self.tags = IOHelper.expandTags(rawTags).filter { !$0.isEmpty }
            
        } else {
            // No tags found in Core Data.
            self.parentTagObject = nil
            self.tags = []
        }
    }
    
    /// Adds a new tag from the `newTagText` property.
    func addNewTag() {
        let trimmedTag = newTagText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Guard against empty or duplicate tags
        guard !trimmedTag.isEmpty, !tags.contains(trimmedTag) else {
            newTagText = "" // Clear field even if it's a duplicate
            return
        }
        
        // Add to the local array and save.
        self.tags.append(trimmedTag)
        self.newTagText = ""
        persistTags()
    }
    
    /// Deletes one or more tags from the list.
    func deleteTag(at offsets: IndexSet) {
        self.tags.remove(atOffsets: offsets)
        persistTags()
    }
    
    // MARK: - Private Helper
    
    /// Saves the current `tags` array back to Core Data.
    private func persistTags() {
        // Join the array back into a semicolon-separated string.
        let combinedString = IOHelper.combineTag(self.tags)
        
        if let tagToUpdate = self.parentTagObject {
            // An object already exists, so update it.
            repo.updateParentValueTag(tag: tagToUpdate, newName: combinedString)
        } else {
            // This is the first time saving. Create a new object.
            repo.addParentValueTag(name: combinedString)
            
            // After adding, we must reload to get the new object
            // so future saves become updates, not new additions.
            loadTags()
        }
    }
}
