//
//  FieldState.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

enum FieldState {
    case empty
    case created
    case approved
    case needToTalk
    case declined
    case done
    
    var stringValue: String {
        switch self {
        case .empty:
            return "Empty"
        case .created:
            return "Created"
        case .approved:
            return "Approved"
        case .needToTalk:
            return "NeedToTalk"
        case .declined:
            return "Declined"
        case .done:
            return "Done"
        }
    }
    
    //TODO: Kurang .declined, .needToTalk
    var fieldAsset: String? {
        switch self {
        case .created, .approved:
            return "FieldSmall"
        case .done:
            return "FieldBig"
        default:
            return nil
        }
    }
    
    var CTAButtonTitle: String? {
        switch self {
        case .approved:
            return "Siram"
        case .done:
            return "Panen"
        default:
            return nil
        }
    }
    
    var CTAButtonImage: String? {
        switch self {
        case .approved, .done:
            return "CTAImage\(stringValue)"
        default:
            return nil
        }
    }
    
    var thoughtBubbleImage: String? {
        switch self {
        case .created, .approved, .done:
            return "ThoughtBubble\(stringValue)"
        default:
            return nil
        }
    }
}
