//
//  ChildrenLogState.swift
//  MonKi
//
//  Created by William on 06/11/25.
//

enum LogState {
    case logOnly
    case logWaiting
    case logDeclined
    case logApproved
    case logDone
    
    var stringValue: String {
        switch self {
        case .logOnly:
            return "LogOnly"
        case .logWaiting:
            return "LogWaiting"
        case .logDeclined:
            return "LogDeclined"
        case .logApproved:
            return "LogApproved"
        case .logDone:
            return "LogDone"
        }
    }
    
    init(state: String) {
        switch state {
        case "LogOnly":
            self = .logOnly
        case "LogWaiting":
            self = .logWaiting
        case "LogDeclined":
            self = .logDeclined
        case "LogApproved":
            self = .logApproved
        case "LogDone":
            self = .logDone
        default:
            self = .logOnly
        }
    }
}
