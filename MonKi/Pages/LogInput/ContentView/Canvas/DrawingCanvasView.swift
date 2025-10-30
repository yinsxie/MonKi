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
        drawLines(lines, ctx)
        if let line = currentLine {
            drawLines([line], ctx)
        }
    }
    private func drawLines(_ lines: [Line], _ ctx: CGContext) {
        lines.forEach { line in
            guard let first = line.points.first else { return }

            let path = UIBezierPath()
            path.move(to: first)
            line.points.dropFirst().forEach { path.addLine(to: $0) }
            path.lineWidth = line.lineWidth
            path.lineCapStyle = .round

//            // Use clear blend mode to erase when needed
//            ctx?.setBlendMode(line.color == .clear ? .clear : .normal)
            line.color.setStroke()
            ctx.setBlendMode(line.color == .clear ? .clear : .normal)
            path.stroke()
        }
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
    func getSnapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
        return renderer.image { context in
            self.layer.render(in: context.cgContext)
        }
    }
}

// MARK: - SwiftUI Wrapper (DrawingCanvasView)
struct DrawingCanvasView: UIViewRepresentable {
    @EnvironmentObject var viewModel: CanvasViewModel

    func makeUIView(context: Context) -> FingerCanvasView {
        return FingerCanvasView()
    }

    func updateUIView(_ uiView: FingerCanvasView, context: Context) {
        if viewModel.takeSnapshot {
            let snapshot = uiView.getSnapshot()
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
    }
}
