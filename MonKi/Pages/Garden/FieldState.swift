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
    case declined
    case done
    
    init(state: String){
        switch state {
        case "Created":
            self = .created
        case "Approved":
            self = .approved
        case "Declined":
            self = .declined
        case "Done":
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
        default:
            return nil
        }
    }
    
    var CTAButtonImage: String? {
        switch self {
        case .approved, .done, .declined:
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
