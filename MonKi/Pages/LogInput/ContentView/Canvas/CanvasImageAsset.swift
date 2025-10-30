//
//  ImageAsset.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

import SwiftUI
import UIKit

enum CanvasImageAsset {
    case canvasBackground
    case canvasViewCloth
    case canvasViewPaperNote
    case canvasViewButton
    
    var imageName: String {
        switch self {
        case .canvasViewCloth:
            return "CanvasViewCloth"
        case .canvasViewPaperNote:
            return "CanvasViewPaperNote"
        case .canvasBackground:
            return "CanvasBackground"
        case .canvasViewButton:
            return "CanvasBackgroundButton"
        }
    }
}

enum ColoredPencilAsset: CaseIterable {
    case canvasViewVioletPencil
    case canvasViewCrimsonPencil
    case canvasViewRedPencil
    case canvasViewOrangePencil
    case canvasViewYellowPencil
    case canvasViewGreenPencil
    case canvasViewBluePencil
    case canvasViewWhitePencil
    case canvasViewBlackPencil
    
    var imageName: String {
        switch self {
        case .canvasViewVioletPencil:
            return "CanvasViewVioletPencil"
        case .canvasViewCrimsonPencil:
            return "CanvasViewCrimsonPencil"
        case .canvasViewRedPencil:
            return "CanvasViewRedPencil"
        case .canvasViewOrangePencil:
            return "CanvasViewOrangePencil"
        case .canvasViewYellowPencil:
            return "CanvasViewYellowPencil"
        case .canvasViewGreenPencil:
            return "CanvasViewGreenPencil"
        case .canvasViewBluePencil:
            return "CanvasViewBluePencil"
        case .canvasViewWhitePencil:
            return "CanvasViewWhitePencil"
        case .canvasViewBlackPencil:
            return "CanvasViewBlackPencil"
        }
    }
    
    var hex: String {
        switch self {
        case .canvasViewVioletPencil:
            return "#B300C0"
        case .canvasViewCrimsonPencil:
            return "#E30069"
        case .canvasViewRedPencil:
            return "#FF3250"
        case .canvasViewOrangePencil:
            return "#FF8500"
        case .canvasViewYellowPencil:
            return "#FFC742"
        case .canvasViewGreenPencil:
            return "#51C23C"
        case .canvasViewBluePencil:
            return "#0099F7"
        case .canvasViewWhitePencil:
            return "#FFFFFF"
        case .canvasViewBlackPencil:
            return "#3D3D3D"
        }
    }
    
    var color: UIColor {
        return Color(hex: self.hex).uiColor
    }
    
}
