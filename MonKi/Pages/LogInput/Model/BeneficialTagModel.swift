//
//  BeneficialTagModel.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 29/10/25.
//

import SwiftUI

enum TagDisplayState {
    case active
    case selected
    case unselected
}

// MARK: - 1. Tag Data Model (Enum)
enum BeneficialTag: String, CaseIterable, Identifiable, Hashable {
    case star, circle, cloud, hexagon, square, triangle
    
    var id: String { self.rawValue }
    
    func assetName(for state: TagDisplayState) -> String {
        let rootName: String
        switch self {
        case .star: rootName = "TagStar"
        case .circle: rootName = "TagCircle"
        case .cloud: rootName = "TagCloud"
        case .hexagon: rootName = "TagPolygon"
        case .square: rootName = "TagSquare"
        case .triangle: rootName = "TagTriangle"
        }
        
        let suffix: String
        switch state {
        case .active:
            suffix = "Default"
        case .selected:
            suffix = "Selected"
        case .unselected:
            suffix = "Unselected"
        }
        
        return "\(rootName)\(suffix)"
    }
    
    var textColor: Color {
        switch self {
        case .triangle: return Color(hex: "#AA0000")
        case .square: return Color(hex: "#5C7100")
        case .hexagon: return Color(hex: "#AA7204")
        case .cloud: return Color(hex: "#396AA9")
        case .star: return Color(hex: "#B83A00")
        case .circle: return Color(hex: "#B93D7E")
        }
    }
}
