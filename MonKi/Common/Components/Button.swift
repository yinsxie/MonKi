//
//  CustomButtonComponent.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import SwiftUI

struct CustomButton: View {
    enum ButtonType {
        case normal
        case bordered
    }
    
    let text: String?
    let backgroundColor: Color
    let foregroundColor: Color
    let textColor: Color
    let font: Font
    let image: String?
    let action: () -> Void
    let cornerRadius: CGFloat
    let width: CGFloat
    let type: ButtonType
    
    init(
        text: String? = nil,
        backgroundColor: Color,
        foregroundColor: Color,
        textColor: Color,
        font: Font = .headlineEmphasized,
        image: String? = nil,
        action: @escaping () -> Void,
        cornerRadius: CGFloat = 12,
        width: CGFloat = .infinity,
        type: ButtonType = .normal
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.textColor = textColor
        self.font = font
        self.image = image
        self.action = action
        self.cornerRadius = cornerRadius
        self.width = width
        self.type = type
    }
    
    init(
        text: String? = nil,
        colorSet: ButtonColorSet,
        font: Font = .headlineEmphasized,
        image: String? = nil,
        action: @escaping () -> Void,
        cornerRadius: CGFloat = 12,
        width: CGFloat = .infinity,
        type: ButtonType = .normal
    ) {
        self.init(
            text: text,
            backgroundColor: colorSet.backgroundColor,
            foregroundColor: colorSet.foregroundColor,
            textColor: colorSet.textColor,
            font: font,
            image: image,
            action: action,
            cornerRadius: cornerRadius,
            width: width,
            type: type
        )
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let image = image {
                    Image(systemName: image)
                        .font(font)
                        .foregroundStyle(textColor)
                }
                
                if let text = text, !text.isEmpty {
                    Text(text)
                        .foregroundStyle(textColor)
                        .font(font)
                }
            }
            .frame(maxWidth: .infinity)
            
        }
        .buttonStyle(CustomButtonStyle(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            cornerRadius: cornerRadius,
            shape: type == .normal ? .rectangle : .borderedRectangle
            
        ))
        .frame(width: width, height: 60)
        .contentShape(Rectangle())
    }
}

struct CustomButtonComponent_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            
            // Normal Button
            CustomButton(
                text: "Normal Button",
                colorSet: .primary,
                image: "arrow.right",
                action: {},
                type: .normal,
            )
            
            // Previous Button (has border)
            CustomButton(
                text: "Previous Button",
                colorSet: .normal,
                image: "arrow.left",
                action: {},
                type: .bordered,
            )
            
            // Icon-only Previous Button
            CustomButton(
                colorSet: .cancel,
                image: "arrow.left",
                action: {},
                width: 70,
                type: .bordered,
            )
            
            // --- NEW: Custom Font Button ---
            CustomButton(
                colorSet: .primary,
                font: .system(size: 36, weight: .black, design: .rounded),
                image: "arrow.left",
                action: {},
                width: 72,
                type: .normal
            )
            
            // --- NEW: Custom Color & Font Button ---
            CustomButton(
                backgroundColor: ColorPalette.yellow600,
                foregroundColor: ColorPalette.yellow400,
                textColor: ColorPalette.yellow50,
                image: "star.fill",
                action: {},
                width: 70,
                type: .normal
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
