//
//  Models.swift
//  MonKi
//
//  Created by William on 27/10/25.
//


// case logOnly
// case logApproved
// case logWaiting
// case Declined
enum ChildrenLogState {
    case created
    case approved
    case declined
    case done
    case archived
    
    var stringValue: String {
        switch self {
        case .created:
            return "Created"
        case .approved:
            return "Approved"
        case .declined:
            return "Declined"
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
        case "Declined":
            self = .declined
        case "Done":
            self = .done
        case "Archived":
            self = .archived
        default:
            self = .created
        }
    }
}
