//
//  GardenViewModel.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

import SwiftUI

@MainActor
final class GardenViewModel: ObservableObject {
    
    // no need manual loading with @FetchRequest
    //    @Published var isLoading: Bool = true
    //    @Published var logs: [MsLog] = []
    
    @Published var imageEventBuffer: UIImage?
    @Published var alertConfirmationType: GardenShovelModality?
    @Published var isShovelMode: Bool = false
    
    @Published var currIndex: Int = 0
    let pageSize: Int = 4
    
    var logRepo: LogRepositoryProtocol
    
    init(logRepo: LogRepositoryProtocol = LogRepository()) {
        self.logRepo = logRepo
    }
    
    func navigateToHome(context: NavigationManager) {
        context.popLast()
    }
    
    func navigateTo(route: MainRoute, context: NavigationManager) {
        context.goTo(route)
    }
    
    func navigateBack(context: NavigationManager) {
        context.popLast()
    }
    
    func onFieldTapped(forLog log: MsLog?, forFieldType type: FieldState, gateManager: ParentalGateManager, context: NavigationManager) {
        switch type {
        case .empty:
            context.goTo(.log)
        case .created:
            guard let logToEdit = log else { return }
            gateManager.gateDestination = .reviewLogFromGarden(log: logToEdit)
        default:
            return
        }
    }
    
    func handleCTAButtonTapped(forLog log: MsLog?, withType type: FieldState, context: NavigationManager, logImage: UIImage? = nil) {
        if let log = log {
            switch type {
            case .approved:
                onApproveFieldTapped(log, context: context)
            case .done:
                onDoneFieldTapped(log, context: context)
            case .declined:
                onDeclinedFieldTapped(log, context: context)
            default:
                return
            }
        }
    }
    
    func pushReplaceToCollectibleView(context: NavigationManager) {
    }
    
    // no need manual loading with @FetchRequest
    //    func fetchLogData() {
    //        logs = []
    //        isLoading = true
    //        logs = logRepo.fetchGardenLogs()
    //        isLoading = false
    //    }
    
    func enableShovelModeAlert(toType type: GardenShovelModality?) {
        alertConfirmationType = type
    }
    
    // Pagination Logic
    
    func maxPage(totalLogs: Int) -> Int {
        return (totalLogs / pageSize) + 1
    }
    
    /// Slices the full FetchedResults array into a small array for the current page
    func getPagedLogs(from allLogs: FetchedResults<MsLog>) -> [MsLog] {
        // Check if the index is invalid (e.g., from logs being deleted)
        let maxPageIndex = self.maxPage(totalLogs: allLogs.count) - 1
        if currIndex > maxPageIndex {
            // We're on a page that shouldn't exist. Reset to the last valid page.
            DispatchQueue.main.async {
                self.currIndex = max(0, maxPageIndex)
            }
            return [] // Return empty for this render pass
        }
        
        // At this point, the page index is valid (e.g., 0 or 1 for 4 logs)
        let start = currIndex * pageSize
        
        // Check if this valid page is simply the "empty" page
        if start >= allLogs.count {
            return []
        }
        
        // If we're here, it's a normal page with logs on it.
        let end = min(start + pageSize, allLogs.count)
        return Array(allLogs[start..<end])
    }
    
    func incrementPage(totalLogs: Int) {
        if currIndex < maxPage(totalLogs: totalLogs) - 1 {
            currIndex += 1
        }
    }
    
    func decrementPage() {
        if currIndex > 0 {
            currIndex -= 1
        }
    }
}

private extension GardenViewModel {
    func bufferImageFromLogForEvent(_ log: MsLog, completion: @escaping (Bool) -> Void) {
        if let imagePath = log.imagePath, let image = ImageStorage.loadImage(from: imagePath) {
            imageEventBuffer = image
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func onApproveFieldTapped(_ log: MsLog, context: NavigationManager) {
        bufferImageFromLogForEvent(log) { success in
            guard success else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let logId = log.id {
                    //                    self.logRepo.logDone(withId: logId)
                }
            }
        }
    }
    
    func onDoneFieldTapped(_ log: MsLog, context: NavigationManager) {
        bufferImageFromLogForEvent(log) { success in
            guard success else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let logId = log.id {
                    UserDefaultsManager.shared.decrementCurrentFilledField(by: 1)
                    //                    self.logRepo.logArchieved(withId: logId)
                }
            }
        }
    }
    
    func onDeclinedFieldTapped(_ log: MsLog, context: NavigationManager) {
    }
    
}
