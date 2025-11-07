//
//  FieldState.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

import SwiftUI

enum FieldState {
    case empty
    case created
    case approved
    case waiting
    case declined
    case done
    
    init(state: String) {
        
        switch state {
        case "LogOnly":
            self = .created
        case "LogWaiting":
            self = .waiting
        case "LogApproved":
            self = .approved
        case "LogDeclined":
            self = .declined
        case "LogDone":
            self = .done
        default:
            self = .empty
        }
    }
    
    var stringValue: String {
        switch self {
        case .empty:
            return "Empty"
        case .created:
            return "Created"
        case .approved:
            return "Approved"
        case .waiting:
            return "Waiting"
        case .declined:
            return "Declined"
        case .done:
            return "Done"
        }
    }
    
    //TODO: Kurang .declined, .needToTalk
    var fieldAsset: String? {
        switch self {
        case .created, .approved, .waiting:
            return "FieldSmall"
        case .done:
            return "FieldBig"
        case .declined:
            return "FieldSmallDeclined"
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
        case .declined:
            return "Ulang"
        case .created:
            return "Cangkul"
        default:
            return nil
        }
    }
    
    var CTAButtonImage: String? {
        switch self {
        case .approved, .done, .declined, .created:
            return "CTAImage\(stringValue)"
        default:
            return nil
        }
    }
    
    // (Primary,Secondary)
    var CTAButtonColor: (Color, Color) {
        switch self {
        case .declined:
            return (ColorPalette.pink100, ColorPalette.pink200)
        case .created:
            return (ColorPalette.yellow100, ColorPalette.yellow200)
        default:
            return (ColorPalette.blue100, ColorPalette.blue200)
        }
    }
    
    var thoughtBubbleImage: String? {
        switch self {
        case .created, .approved, .done, .declined:
            return "ThoughtBubble\(stringValue)"
        default:
            return nil
        }
    }
}
