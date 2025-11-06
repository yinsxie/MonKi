//
//  ReviseLogViewModel.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 01/11/25.
//

import SwiftUI
import CoreData

@MainActor
final class ReLogViewModel: ObservableObject {
    
    // MARK: - Navigation
    @Published var currentIndex: Int = 0
    
    // MARK: - State
    // These properties will be bound to the UI
    @Published var happyLevel: Int
    @Published var hasSlide: Bool = false
    @Published var selectedBeneficialTags = Set<BeneficialTag>()
    var sliderImage: UIImage
    
    // MARK: - Injected Properties
    private let logId: UUID
    private let logRepository: LogRepositoryProtocol
    var parentValueTagRepo: ParentValueTagRepositoryProtocol
    
    var monkiImageName: String {
            switch self.happyLevel {
            case 0:
                return "monki_default"
            case 1:
                return "monki_happy"
            case 2:
                return "monki_veryhappy"
            default:
                return "monki_default"
            }
        }
    
    // MARK: - Tag Data
    @Published var beneficialTagsString: String = ""

    var beneficialTagLabels: [String] {
        return IOHelper.expandTags(beneficialTagsString)
    }

    // MARK: - Computed Properties
    var pageCount: Int {
        ReLogPageEnum.allCases.count
    }

    // MARK: - Initialization
    
    /// Creates a new ViewModel to edit an existing log.
    init(logToEdit: MsLog, logRepository: LogRepositoryProtocol = LogRepository()) {
        self.logRepository = logRepository
        self.parentValueTagRepo = ParentValueTagRepository()
        
        // We only store the ID, as requested.
        guard let id = logToEdit.id else {
            // This should ideally be handled, but for now we'll fatalError
            // or assign a dummy UUID if we can't proceed.
            fatalError("Attempted to edit a log with no ID.")
        }
        self.logId = id
        
        // --- Load Initial State From MsLog ---
        
        // 1. Load 'isHappy' state
        // We map the Bool back to the String expected by the UI ("Happy" or "Biasa")
//        self.tagSelectedMode = logToEdit.isHappy ? "Happy" : "Biasa"
        
        self.happyLevel = Int(logToEdit.happyLevel)
        
        self.sliderImage = UIImage(named: logToEdit.imagePath ?? "icecream_placeholder") ?? UIImage(systemName: "face.smiling.fill") ?? UIImage()
        
        // 2. Load 'beneficialTags' state
        fetchBeneficialTags()

        let allLabels = self.beneficialTagLabels
        // Assuming BeneficialTag enum is available and CaseIterable
        let allShapes = BeneficialTag.allCases
        
        // Create a reverse map [String: BeneficialTag] to find the enum case for a label
        let reverseTagMap = Dictionary(uniqueKeysWithValues: zip(allLabels, allShapes))
        
        // Expand the saved string (e.g., "Sehat;Pintar") into an array (e.g., ["Sehat", "Pintar"])
        let savedTagLabels = IOHelper.expandTags(logToEdit.beneficialTags ?? "")
        
        // Convert the string labels back into the Set<BeneficialTag>
        self.selectedBeneficialTags = Set(savedTagLabels.compactMap { reverseTagMap[$0] })
    }
    
    // MARK: - Navigation Logic
    
    func handleNextAction(onClose: @escaping () -> Void) {
        if currentIndex < pageCount - 1 {
            // Not the last page, just move forward
            withAnimation { currentIndex += 1 }
        } else {
            // This is the last step, so save and close
            saveChanges()
            onClose()
        }
    }
    
    func handleBackAction() {
        if currentIndex > 0 {
            withAnimation { currentIndex -= 1 }
        }
    }
    
    /// Logic to disable the "Next" button.
    func shouldDisableNext() -> Bool {
        guard let page = ReLogPageEnum(rawValue: currentIndex) else { return false }
        
        switch page {
        case .howHappy:
            // either change or not, child can be continue
            return false
        case .howBeneficial:
            // This is the last page, "Next" (Done) is always enabled
            return false
        }
    }
    
    // MARK: - Save Logic
    
    private func saveChanges() {
        // --- Prepare Data for Repository ---
        
        // 1. Convert 'tagSelectedMode' string back to 'isHappy' Bool
        let happy = true //TODO: delete param at another ticket
        let happyLvl = self.happyLevel
        
        // 2. Convert 'Set<BeneficialTag>' back to '[String]'
        let allLabels = self.beneficialTagLabels
        let allShapes = BeneficialTag.allCases
        let tagMap = Dictionary(uniqueKeysWithValues: zip(allShapes, allLabels))
        
        let selectedLabels = selectedBeneficialTags.compactMap { tagMap[$0] }
        
        // 3. Determine 'isBeneficial'
        let beneficial = !selectedLabels.isEmpty
        
        
        // TODO: kerja page verdict dulu boss
//        logRepository.logContinued(forLog: logId, happyLevel: happyLvl, tags: selectedLabels, withVerdict: <#T##ParentLogVerdict#>)
        
        // --- Call Repository ---
        // We call the repository function, we don't edit the object directly.
//        logRepository.childRelogged(
//            withId: logId,
//            isHappy: happy,
//            // MARK: CHANGE THIS
//            happyLevel: happyLvl,
//            isBeneficial: beneficial,
//            tags: selectedLabels
//        )
//
//        print("ReLog: Save complete for log \(logId).")
    }
    
    private func fetchBeneficialTags() {
            if let tagsObject = parentValueTagRepo.fetchAllParentValueTags().first {
                self.beneficialTagsString = tagsObject.valueTag ?? ""
            } else {
                print("LOG: No ParentValueTag found in Core Data. Beneficial tags will be empty.")
                self.beneficialTagsString = ""
            }
        }
}
