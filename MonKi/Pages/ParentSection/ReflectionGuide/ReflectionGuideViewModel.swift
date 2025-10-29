//
//  ReflectionGuideViewModel.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 28/10/25.
//

import Foundation
import Combine
import CoreData

final class ReflectionGuideViewModel: ObservableObject {
    
    @Published var log: MsLog
    
    private let logRepository: LogRepositoryProtocol
    
    init(log: MsLog, logRepository: LogRepositoryProtocol = LogRepository()) {
        self.log = log
        self.logRepository = logRepository
    }
    
}
