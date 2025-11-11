//
//  ParentalGateManager.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 06/11/25.
//

import SwiftUI
import Combine

enum ProtectedDestination: Identifiable, Hashable {
    case parentSettings
    case reviewLogFromGarden(log: MsLog)
//    case reviewLogOnFirstLog
//    case checklistUpdate

    var id: Self { self }
}

@MainActor
final class ParentalGateManager: ObservableObject {
    @Published var gateDestination: ProtectedDestination?
}
