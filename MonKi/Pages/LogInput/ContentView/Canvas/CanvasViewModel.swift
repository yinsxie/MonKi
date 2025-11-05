//
//  CanvasViewModel.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI
import UIKit

struct Line {
    var points: [CGPoint]
    var color: UIColor
    var lineWidth: CGFloat
}

enum CanvasActionType {
    case undo
    case redo
}

@MainActor
final class CanvasViewModel: ObservableObject {
    
    // MARK: - Drawing State
    @Published var selectedPencil: ColoredPencilAsset? = .canvasViewBlackPencil
    @Published var canvasToolSelected: CanvasToolType?
    @Published var isEraserEnabled: Bool = false
    @Published var onGoingAction: CanvasActionType?
    
    // Line widths (points)
    @Published var lineWidth: CGFloat = 7.5
    @Published var eraserWidth: CGFloat = 15
    
    // MARK: - Snapshot & Processing State
    @Published var takeSnapshot: Bool = false
    @Published var processedImage: UIImage?
    @Published var isProcessing: Bool = false
    
    // MARK: Navigation Flow State (Block
    @Published var isExistDrawing: Bool = false
    
    // MARK: - Dependencies
    private let composer = BackgroundRemoverImageComposer()
    private let processor = BackgroundRemoverProcessor()
    var onDrawingProcessed: ((UIImage?) -> Void)?
    
    // MARK: - Tool Selection Methods
    func toggleColoredPencil(to pencil: ColoredPencilAsset) {
        self.isEraserEnabled = false
        self.selectedPencil = pencil
        self.canvasToolSelected = nil
    }
    
    func toggleEraser() {
        self.canvasToolSelected = .delete
        self.selectedPencil = nil
        self.isEraserEnabled = true
    }
    
    func handleAction(forAction type: CanvasActionType) {
        self.onGoingAction = type
    }
    
    // MARK: - Snapshot & Processing Methods
    func saveDrawing() {
        guard !isProcessing else { return }
        print("CanvasViewModel: Initiating snapshot...")
        self.isProcessing = true
        self.processedImage = nil
        self.takeSnapshot = true
    }
    
    func processDrawing(snapshot: UIImage?) {
        guard let snapshot = snapshot else {
            Task {
                await MainActor.run {
                    self.isProcessing = false
                    self.onDrawingProcessed?(nil)
                }
            }
            return
        }
        
        Task {
            do {
                let result = try await composer.processDrawing(snapshot)
                
                await MainActor.run {
                    self.processedImage = result
                    
                    self.isProcessing = false
                    self.onDrawingProcessed?(result)
                }
            } catch {
                await MainActor.run {
                    self.isProcessing = false
                    self.processedImage = nil
                    self.onDrawingProcessed?(nil)
                }
            }
        }
    }
}
