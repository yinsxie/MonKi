//
//  Models.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

enum ChildrenLogState {
    case created
    case approved
    case rejected
    case done
    case archived
    
    var stringValue: String {
        switch self {
        case .created:
            return "Created"
        case .approved:
            return "Approved"
        case .rejected:
            return "Rejected"
        case .done:
            return "Done"
        case .archived:
            return "Archived"
        }
    }
   
    init(state: String) {
        switch state {
        case "Created":
            self = .created
        case "Approved":
            self = .approved
        case "Need to Talk":
            self = .needToTalk
        case "Rejected":
            self = .rejected
        case "Done":
            self = .done
        case "Archived":
            self = .archived
        default:
            self = .created
        }
    }
}
