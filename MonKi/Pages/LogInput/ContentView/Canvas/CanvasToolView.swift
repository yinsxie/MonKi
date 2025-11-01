//
//  CanvasToolView.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

enum CanvasToolType {
    case delete
    case undo
    case redo
    
    var defaultAssetName: String {
        switch self {
        case .delete:
            return "CanvasToolDelete"
        case .undo:
            return "CanvasToolUndo"
        case .redo:
            return "CanvasToolRedo"
        }
    }
    
    var selectedAssetName: String {
        return "\(defaultAssetName)Selected"
    }
}

struct CanvasToolView: View {
    
    @ObservedObject var viewModel: CanvasViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            
            CanvasToolButton(toolType: .undo) {
                viewModel.handleAction(forAction: .undo)
            }
            
            CanvasDeleteToolButton(toolType: .delete, isEnabled: $viewModel.isEraserEnabled) {
                viewModel.toggleEraser()
            }
            
            CanvasToolButton(toolType: .redo) {
                viewModel.handleAction(forAction: .redo)
            }
        }
    }
}

struct CanvasDeleteToolButton: View {
    let size: CGFloat = 67
    
    var toolType: CanvasToolType
    @Binding var isEnabled: Bool
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Image(isEnabled ? toolType.selectedAssetName : toolType.defaultAssetName)
                .resizable()
                .frame(width: size, height: size)
        }
    }
}

struct CanvasToolButton: View {
    
    let size: CGFloat = 67
    var toolType: CanvasToolType
    var onClick: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button {
            onClick()
            switch toolType {
                case .undo:
                    SoundManager.shared.play(.popUredo)
                case .redo:
                    SoundManager.shared.play(.popUredo)
                default:
                    break
                }
        } label: {
            Image(isPressed ? toolType.selectedAssetName : toolType.defaultAssetName)
                .resizable()
                .frame(width: size, height: size)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}
