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
    @Published var allValues: [String] = []
    @Published var selectedValues: Set<String> = []
    @Published var isShowingAddValueSheet = false
    @Published var customValueText: String = ""
    
    private let staticValues: [String] = [
        "Belajar", "Disiplin", "Rajin", "Mandiri", "Hemat", "Baca",
        "Kreatif", "Hobi", "Berbagi", "Kuat", "Sehat", "Pintar",
        "Peduli"
    ]
    
    let minSelection = 1
    let maxSelection = 6
    let maxCustomValueChars = 10
    
    // MARK: - Computed Properties
    var isContinueButtonEnabled: Bool {
        (minSelection...maxSelection).contains(selectedValues.count)
    }
    
    func isSelected(_ value: String) -> Bool {
        selectedValues.contains(value)
    }
    
    var isAddButtonDisabled: Bool {
        let trimmedText = customValueText.trimmingCharacters(in: .whitespaces)
        return trimmedText.isEmpty || allValues.contains(trimmedText)
    }
    
    var customValueCharacterCount: Int {
        customValueText.count
    }
    
    // MARK: - Core Data Properties
    private let repo: ParentValueTagRepositoryProtocol
    private var parentTagObject: ParentValueTag?
    
    // MARK: - Initialization
    init(repo: ParentValueTagRepositoryProtocol = ParentValueTagRepository()) {
        self.repo = repo
    }
    
    // MARK: - Core Functions
    
    func loadTags() {
        let tagObjects = repo.fetchAllParentValueTags()
        
        let previouslySavedTags: [String]
        
        if let firstTagObject = tagObjects.first {
            self.parentTagObject = firstTagObject
            let rawTags = firstTagObject.valueTag ?? ""
            previouslySavedTags = IOHelper.expandTags(rawTags).filter { !$0.isEmpty }
            
        } else {
            self.parentTagObject = nil
            previouslySavedTags = []
        }
        
        // populate the selected values
        self.selectedValues = Set(previouslySavedTags)
    
        // populate all values, find any custom tags that are not in the static list
        let staticSet = Set(staticValues)
        let customTags = previouslySavedTags.filter { !staticSet.contains($0) }
        
        self.allValues = staticValues + customTags
    }
    
    func toggleSelection(for value: String) {
        if selectedValues.contains(value) {
            selectedValues.remove(value)
        } else {
            guard selectedValues.count < maxSelection else { return }
            selectedValues.insert(value)
        }
        
        persistTags()
    }
    
    func addCustomValue() {
        let trimmedText = customValueText.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedText.isEmpty, !allValues.contains(trimmedText) else {
            return
        }
        
        allValues.append(trimmedText)
        
        if selectedValues.count < maxSelection {
            selectedValues.insert(trimmedText)
        }
        
        persistTags()
        
        customValueText = ""
        isShowingAddValueSheet = false
    }
    
    func limitCustomValueText() {
        if customValueText.count > maxCustomValueChars {
            customValueText = String(customValueText.prefix(maxCustomValueChars))
        }
    }
    
    // MARK: - Private Helper
    private func persistTags() {
        let combinedString = IOHelper.combineTag(Array(self.selectedValues))
        
        if let tagToUpdate = self.parentTagObject {
            repo.updateParentValueTag(tag: tagToUpdate, newName: combinedString)
        } else {
            repo.addParentValueTag(name: combinedString)
            loadTags()
        }
    }
}
