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
    
    func onFieldTapped(forFieldType type: FieldState, context: NavigationManager) {
        switch type {
        case .empty:
            context.goTo(.childLog(.logInput))
        default:
            return
        }
        
    }
    
    func handleCTAButtonTapped(forLog log: MsLog?, withType type: FieldState, context: NavigationManager, bufferData: GardenFullDataBuffer? = nil, logImage: UIImage? = nil) {
        if let log = log {
            switch type {
            case .approved:
                onApproveFieldTapped(log, context: context)
            case .done:
                onDoneFieldTapped(log, context: context)
            case .declined:
                onDeclinedFieldTapped(log, context: context)
            case .created:
                onShovelFieldTapped(log, buffer: bufferData, logImage: logImage)
                DispatchQueue.main.async {
                    self.fetchLogData()
                }
            default:
                return
            }
        }
    }
    
    func pushReplaceToCollectibleView(context: NavigationManager) {
        context.replaceTopAnimate(with: .childGarden(.collectible))
    }
    
    func fetchLogData() {
        logs = []
        isLoading = true
        logs = logRepo.fetchLogs()
        isLoading = false
    }
    
    func enableShovelModeAlert(toType type: GardenShovelModality?) {
        alertConfirmationType = type
    }
        
    func validateShovelMode(bufferData: GardenFullDataBuffer?) {
        isShovelMode = bufferData != nil
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
            
            context.goTo(.childGarden(.watering))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let logId = log.id {
                    self.logRepo.logDone(withId: logId)
                }
            }
        }
    }

    func onDoneFieldTapped(_ log: MsLog, context: NavigationManager) {
        bufferImageFromLogForEvent(log) { success in
            guard success else { return }
            
            context.goTo(.childGarden(.harvesting))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let logId = log.id {
                    UserDefaultsManager.shared.decrementCurrentFilledField(by: 1)
                    self.logRepo.logArchieved(withId: logId)
                }
            }
        }
    }
    
    func onDeclinedFieldTapped(_ log: MsLog, context: NavigationManager) {
        context.goTo(.reLog(log: log))
    }
    
    func onShovelFieldTapped(_ log: MsLog, buffer: GardenFullDataBuffer? = nil, logImage: UIImage? = nil) {
        if let buffer = buffer, let logImage = logImage {
            let commitType = GardenShovelModality.commit(image: logImage) {
                self.logRepo.logReplaced(replacedLog: log, newImage: buffer.image, isHappy: buffer.isHappy, isBeneficial: buffer.isHappy, tags: buffer.tags)
                
                self.enableShovelModeAlert(toType: nil)
                DispatchQueue.main.async {
                    withAnimation {
                        self.isShovelMode = false
                        self.fetchLogData()
                    }
                }
            }
            enableShovelModeAlert(toType: commitType)
        }
    }
}
