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
            return state == ChildrenLogState.created.stringValue ||
            state == ChildrenLogState.needToTalk.stringValue
        }
        print("Filtered down to \(logsForParent.count) logs for parent view.")
        
        self.logsForParent = logsForParent
    }
}
