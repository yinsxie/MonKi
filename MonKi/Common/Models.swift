//
//  Models.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

enum ChildrenLogState {
    case created
    case approved
    case needToTalk
    case rejected
    case done
    case archived
    
    var stringValue: String {
        switch self {
        case .created:
            return "Created"
        case .approved:
            return "Approved"
        case .needToTalk:
            return "Need to Talk"
        case .rejected:
            return "Rejected"
        case .done:
            return "Done"
        case .archived:
            return "Archived"
        }
    }
    
}
