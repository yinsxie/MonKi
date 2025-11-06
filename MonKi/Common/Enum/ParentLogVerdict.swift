//
//  ParentLogVerdict.swift
//  MonKi
//
//  Created by William on 06/11/25.
//


enum ParentLogVerdict {
    case approved
    case conditional
    case declined
    
    var value: String {
        switch self {
        case .approved:
            return "Approved"
        case .conditional:
            return "Conditional"
        case .declined:
            return "Rejected"
        }
    }
    
    init(value: String) {
        switch value {
        case "Approved":
            self = .approved
        case "Conditional":
            self = .conditional
        case "Rejected":
            self = .declined
        default:
            self = .declined
        }
    }
}
