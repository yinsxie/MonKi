//
//  CanvasViewModel.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

struct Line {
    var points: [CGPoint]
    var color: UIColor
    var lineWidth: CGFloat
}

enum CanvasActionType {
    case undo
    case redo
}

final class CanvasViewModel: ObservableObject {
    
    @Published var selectedPencil: ColoredPencilAsset? = .canvasViewBlackPencil
    @Published var canvasToolSelected: CanvasToolType?
    @Published var isEraserEnabled: Bool = false
    @Published var onGoingAction: CanvasActionType?
    
    // Line widths (points)
    @Published var lineWidth: CGFloat = 7.5
    @Published var eraserWidth: CGFloat = 15
    
    func toggleColoredPencil(to pencil: ColoredPencilAsset) {
        isEraserEnabled = false
        selectedPencil = pencil
    }
    
    func toggleEraser() {
        DispatchQueue.main.async {
            self.canvasToolSelected = .delete
            self.selectedPencil = nil
            self.isEraserEnabled = true
        }
    }
    
    func handleAction(forAction type: CanvasActionType) {
        self.onGoingAction = type
    }
    
}
