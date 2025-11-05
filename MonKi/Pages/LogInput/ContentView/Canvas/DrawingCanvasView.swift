//
//  DrawingCanvasView.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

import UIKit
import SwiftUI

class FingerCanvasView: UIView {
    
    private var lines: [Line] = []
    private var undoneLines: [Line] = []
    private var currentLine: Line?
    
    private var currentColor: UIColor = .black
    private var currentWidth: CGFloat = 10
    private var isEraser: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        isMultipleTouchEnabled = true
        backgroundColor = .clear
        isOpaque = false
    }
    
    func setColor(_ color: UIColor) { self.currentColor = color }
    func enableEraser(_ enabled: Bool) { self.isEraser = enabled }
    func setLineWidth(_ width: CGFloat) { self.currentWidth = width }
    
    // MARK: Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        undoneLines.removeAll()
        guard let point = touches.first?.location(in: self) else { return }
        
        let color = isEraser ? UIColor.clear : currentColor
        currentLine = Line(points: [point], color: color, lineWidth: currentWidth)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              var line = currentLine else { return }
        
        line.points.append(touch.location(in: self))
        currentLine = line
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let line = currentLine {
            lines.append(line)
        }
        currentLine = nil
        setNeedsDisplay()
    }
    
    // MARK: Draw Canvas
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        drawLines(into: ctx, lines: self.lines)
        if let line = currentLine {
            drawLines(into: ctx, lines: [line])
        }
    }
    
    private func drawLines(into context: CGContext, lines: [Line]) {
        context.saveGState()
        
        lines.forEach { line in
            guard let first = line.points.first else { return }
            
            context.setLineWidth(line.lineWidth)
            context.setLineCap(.round)
            context.setLineJoin(.round)
            context.setStrokeColor(line.color.cgColor)
            
            if line.color == .clear {
                context.setBlendMode(.clear)
            } else {
                context.setBlendMode(.normal)
            }
            
            context.beginPath()
            context.move(to: first)
            line.points.dropFirst().forEach { context.addLine(to: $0) }
            
            context.strokePath()
        }
        
        context.restoreGState()
    }
    
    // MARK: Undo/Redo
    func undo() {
        guard let last = lines.popLast() else { return }
        undoneLines.append(last)
        setNeedsDisplay()
    }
    
    func redo() {
        guard let redoLine = undoneLines.popLast() else { return }
        lines.append(redoLine)
        setNeedsDisplay()
    }
    
    // MARK: - Snapshot Function (Added)
    func getSnapshot(padding: CGFloat) -> UIImage? {
        guard let drawingBounds = calculateDrawingBounds() else {
            return nil
        }
        
        let paddedBounds = drawingBounds.insetBy(dx: -padding, dy: -padding)
        
        let rendererBounds = CGRect(origin: .zero, size: paddedBounds.size)
        let renderer = UIGraphicsImageRenderer(bounds: rendererBounds)
        
        return renderer.image { context in
            let cgContext = context.cgContext
            
            cgContext.setFillColor(UIColor.clear.cgColor)
            cgContext.fill(rendererBounds)
            
            cgContext.translateBy(x: -paddedBounds.origin.x, y: -paddedBounds.origin.y)
            
            drawLines(into: cgContext, lines: self.lines)
            if let line = currentLine {
                drawLines(into: cgContext, lines: [line])
            }
        }
    }
    
    // Calculates the bounding box containing all drawn lines, including their line width.
    private func calculateDrawingBounds() -> CGRect? {
        var activeBounds = CGRect.null
        
        let allLines = lines + (currentLine.map { [$0] } ?? [])
        
        for line in allLines {
            guard let first = line.points.first else { continue }
            
            let path = UIBezierPath()
            path.move(to: first)
            line.points.dropFirst().forEach { path.addLine(to: $0) }
            
            let cgPath = path.cgPath
            
            let strokedPath = cgPath.copy(
                strokingWithWidth: line.lineWidth,
                lineCap: .round,
                lineJoin: .round,
                miterLimit: 0
            )
            
            let pathBounds = strokedPath.boundingBoxOfPath
            
            if activeBounds.isNull {
                activeBounds = pathBounds
            } else {
                activeBounds = activeBounds.union(pathBounds)
            }
        }
        
        return activeBounds.isNull ? nil : activeBounds
    }
    
    // Mark get how much line exist in the current canvas
    func isExistLine() -> Bool {
        return lines.count > 0
    }
}

// MARK: - SwiftUI Wrapper (DrawingCanvasView)
struct DrawingCanvasView: UIViewRepresentable {
    @EnvironmentObject var viewModel: CanvasViewModel
    
    private let outlinePadding: CGFloat = 20.0
    
    func makeUIView(context: Context) -> FingerCanvasView {
        return FingerCanvasView()
    }
    
    func updateUIView(_ uiView: FingerCanvasView, context: Context) {
        if viewModel.takeSnapshot {
            
            let snapshot = uiView.getSnapshot(padding: outlinePadding)
            
            viewModel.processDrawing(snapshot: snapshot)
            
            DispatchQueue.main.async {
                viewModel.takeSnapshot = false
            }
        }
        
        updateCanvas(uiView)
    }
    
    func updateCanvas(_ uiView: FingerCanvasView) {
        if let pencilColor = viewModel.selectedPencil?.color {
            uiView.setColor(pencilColor)
        }
        uiView.enableEraser(viewModel.isEraserEnabled)
        
        // Apply width based on current tool (pencil vs eraser)
        let width = viewModel.isEraserEnabled ? viewModel.eraserWidth : viewModel.lineWidth
        uiView.setLineWidth(width)
        
        if let action = viewModel.onGoingAction {
            switch action {
            case .undo:
                uiView.undo()
            case .redo:
                uiView.redo()
            }
            
            DispatchQueue.main.async {
                viewModel.onGoingAction = nil
            }
        }
        
        // Check if theres a exist a line, to enable the next button
        DispatchQueue.main.async {
            viewModel.isExistDrawing = uiView.isExistLine()
        }
    }
}
