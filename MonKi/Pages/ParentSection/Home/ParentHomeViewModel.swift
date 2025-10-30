//
//  ParentHomeViewModel.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 28/10/25.
//

import Foundation
import Combine

final class ParentHomeViewModel: ObservableObject {
    
    @Published var logsForParent: [MsLog] = []
    
    private let logRepository: LogRepositoryProtocol
    
    init(logRepository: LogRepositoryProtocol = LogRepository()) {
        self.logRepository = logRepository
    }
    
    func loadLogs() {
        let allLogs = logRepository.fetchLogs()
        print("Fetched \(allLogs.count) logs from repository.")
        
        allLogs.forEach { log in
            print("Log ID: \(log.id ?? UUID()), State: \(log.state ?? "NIL")")
        }
        
        let logsForParent = allLogs.filter { log in
            let state = log.state ?? ""
            return state == ChildrenLogState.created.stringValue
        }
        print("Filtered down to \(logsForParent.count) logs for parent view.")
        
        self.logsForParent = logsForParent
    }
    
    func approveLog(log: MsLog) {
            guard let logId = log.id else {
                print("Error: Log ID is nil. Cannot approve.")
                return
            }
            print("Approving log: \(logId)")
            logRepository.logApprovedByParent(withId: logId)
            
            // Remove the log from the published array to update the UI
            DispatchQueue.main.async {
                self.logsForParent.removeAll { $0.id == logId }
            }
        }
        
        func rejectLog(log: MsLog) {
            guard let logId = log.id else {
                print("Error: Log ID is nil. Cannot reject.")
                return
            }
            print("Rejecting log: \(logId)")
            logRepository.logRejectedByParent(withId: logId)
            
            DispatchQueue.main.async {
                self.logsForParent.removeAll { $0.id == logId }
            }
        }
}
