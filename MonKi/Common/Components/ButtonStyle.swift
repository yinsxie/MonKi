//
//  ButtonStyle.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import Foundation
import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    enum Shape {
        case rectangle
        case borderedRectangle
    }
    private var backgroundColor: Color
    private var foregroundColor: Color
    private var shape: Shape
    private var cornerRadius: CGFloat
    private var yOffset: CGFloat
    
    init(
        backgroundColor: Color,
        foregroundColor: Color,
        cornerRadius: CGFloat = 16,
        shape: Shape = .rectangle,
        yOffset: CGFloat = 8
    ) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.cornerRadius = cornerRadius
        self.shape = shape
        self.yOffset = yOffset
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            buttonShape(color: backgroundColor)
            buttonShape(color: foregroundColor).offset(y: configuration.isPressed ? 0 : -yOffset)
            configuration.label.foregroundStyle(backgroundColor).offset(y: -yOffset).offset(y: configuration.isPressed ? yOffset : 0)
        }
    }
    
    @ViewBuilder
    private func buttonShape(color: Color) -> some View {
        switch shape {
        case .rectangle: RoundedRectangle(cornerRadius: cornerRadius).fill(color)
        case .borderedRectangle: RoundedRectangle(cornerRadius: cornerRadius)
                .fill(color)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(backgroundColor, lineWidth: 2.5)
                )
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius + 2.5)
                        .fill(foregroundColor)
                )
                .padding(.horizontal, 2.5)
        }
    }
}

enum ButtonColorSet {
    case primary
    case cancel
    case destructive
    case disabled
    case normal
    case previous
    
    var backgroundColor: Color {
        switch self {
        case .primary: return ColorPalette.blue900
        case .cancel: return ColorPalette.blue200
        case .destructive: return ColorPalette.orange900
        case .disabled: return ColorPalette.neutral200
        case .normal: return ColorPalette.yellow600
        case .previous: return ColorPalette.neutral300
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary: return ColorPalette.blue600
        case .cancel: return ColorPalette.blue100
        case .destructive: return ColorPalette.orange600
        case .disabled: return ColorPalette.neutral300
        case .normal: return ColorPalette.yellow400
        case .previous: return ColorPalette.neutral50
        }
    }
    
    var textColor: Color {
        switch self {
        case .primary: return ColorPalette.neutral50
        case .cancel: return ColorPalette.blue700
        case .destructive: return ColorPalette.neutral50
        case .disabled: return ColorPalette.neutral500
        case .normal: return ColorPalette.yellow900
        case .previous: return ColorPalette.neutral400
        }
    }
}
