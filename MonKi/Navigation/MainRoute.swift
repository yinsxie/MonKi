//
//  MainRoute.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

// Main Route
// - Relog
// - Log
// - Parent Gate
// - Parent Value
// - Collectible
enum MainRoute: Hashable {
    case relog(log: MsLog)
    case log
    case parentGate
    case parentValue
    case collectible
}
