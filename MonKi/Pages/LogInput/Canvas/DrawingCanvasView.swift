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
    private var currentWidth: CGFloat = 100
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
    
    func setColor(_ color: UIColor) {
        currentColor = color
    }
    
    func enableEraser(_ enabled: Bool) {
        isEraser = enabled
    }

    func setLineWidth(_ width: CGFloat) {
        currentWidth = width
    }
    
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
        let ctx = UIGraphicsGetCurrentContext()

        drawLines(lines, ctx)
        if let line = currentLine {
            drawLines([line], ctx)
        }
    }

    private func drawLines(_ lines: [Line], _ ctx: CGContext?) {
        lines.forEach { line in
            guard let first = line.points.first else { return }

            let path = UIBezierPath()
            path.move(to: first)
            for point in line.points.dropFirst() { path.addLine(to: point) }

            ctx?.setLineWidth(line.lineWidth)
            ctx?.setLineCap(.round)
            ctx?.setBlendMode(line.color == .clear ? .clear : .normal)
            line.color.setStroke()
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
}

// MARK: - SwiftUI Wrapper
struct DrawingCanvasView: UIViewRepresentable {
    
    @ObservedObject var viewModel: CanvasViewModel
    
    func makeUIView(context: Context) -> FingerCanvasView {
        let view = FingerCanvasView()
        view.setLineWidth(50)
        return view
    }

    func updateUIView(_ uiView: FingerCanvasView, context: Context) {
        updateCanvas(uiView)
    }
    
    func updateCanvas(_ uiView: FingerCanvasView) {
        if let pencilColor = viewModel.selectedPencil?.color {
            uiView.setColor(pencilColor)
        }
        uiView.enableEraser(viewModel.isEraserEnabled)
        
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
