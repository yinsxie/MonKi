//
//  CollectiblesHomeViewModel.swift
//  MonKi
//
//  Created by William on 04/11/25.
//

import SwiftUI
import Foundation

final class CollectiblesHomeViewModel: ObservableObject {
    
    @Published var currIndex: Int = 0 {
        didSet {
            getPagedArchivedLogs(for: currIndex)
        }
    }
    @Published var maxPage: Int = 0
    
    @Published var listOfArhcivedLogs: [MsLog] = []
    @Published var pagedArchivedLogs: [MsLog] = []
    
    let logRepo: LogRepositoryProtocol
    
    init(logRepo: LogRepositoryProtocol = LogRepository()) {
        self.logRepo = logRepo
        getArchivedLogs()
    }
    
    func getArchivedLogs() {
        listOfArhcivedLogs = logRepo.fetchApprovedLog()
        
        getPagedArchivedLogs(for: 0)
        
        if listOfArhcivedLogs.count > 0 && listOfArhcivedLogs.count % 4 == 0 {
            maxPage = Int(listOfArhcivedLogs.count/4)
        } else {
            maxPage = Int(listOfArhcivedLogs.count/4) + 1
        }
    }
    
    func incrementPage() {
        currIndex += 1
    }
    
    func decrementPage() {
        currIndex -= 1
    }
    
    func getPagedArchivedLogs(for index: Int) {
        let start = index * 4
        guard start < listOfArhcivedLogs.count else {
            pagedArchivedLogs = []
            return
        }
        pagedArchivedLogs = Array(listOfArhcivedLogs.dropFirst(start).prefix(4))
    }
}
