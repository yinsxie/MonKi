//
//  ParentReviewDetailViewModel.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 28/10/25.
//

import Foundation
import Combine
import CoreData // Needed to reference MsLog

final class ParentReviewDetailViewModel: ObservableObject {
    
    @Published var log: MsLog
    @Published var beneficialTags: [String] = []
    
    private let logRepository: LogRepositoryProtocol
    
    init(log: MsLog, logRepository: LogRepositoryProtocol = LogRepository()) {
        self.log = log
        self.logRepository = logRepository
        
        parseBeneficialTags()
    }
        
    private func parseBeneficialTags() {
        guard let tagsString = log.beneficialTags, !tagsString.isEmpty else {
            self.beneficialTags = []
            return
        }
        self.beneficialTags = tagsString.split(separator: ";")
            .map { String($0).trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
    
    func approveLog() {
        guard let logId = log.id else { return }
        print("Approving log: \(logId)")
        logRepository.logApprovedByParent(withId: logId)
    }
    
    func rejectLog() {

        guard let logId = log.id else { return }
        print("NeedToTalkWithParents log: \(logId)")
        logRepository.logNeedToTalkWithParents(withId: logId)

    }
}
