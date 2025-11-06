//
//  GardenViewModel.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

import SwiftUI

@MainActor
final class GardenViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    @Published var logs: [MsLog] = []
    @Published var imageEventBuffer: UIImage?
    @Published var alertConfirmationType: GardenShovelModality?
    @Published var isShovelMode: Bool = false
    
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
    
    func onFieldTapped(forLog log: MsLog?, forFieldType type: FieldState, context: NavigationManager) {
        switch type {
        case .empty:
            context.goTo(.log)
        case .created:
            guard let logToEdit = log else { return }
            context.goTo(.relog(log: logToEdit))
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
    
    func fetchLogData() {
        logs = []
        isLoading = true
        logs = logRepo.fetchDoneLog()
        isLoading = false
    }
    
    func enableShovelModeAlert(toType type: GardenShovelModality?) {
        alertConfirmationType = type
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
