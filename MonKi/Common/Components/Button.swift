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
    let imageRight: String?
    let action: () -> Void
    let cornerRadius: CGFloat
    let width: CGFloat
    let type: ButtonType
    let isDisabled: Bool
    
    @State private var isPressed: Bool = false
    
    init(
        text: String? = nil,
        backgroundColor: Color,
        foregroundColor: Color,
        textColor: Color,
        font: Font = .headlineEmphasized,
        image: String? = nil,
        imageRight: String? = nil,
        action: @escaping () -> Void,
        cornerRadius: CGFloat = 12,
        width: CGFloat = .infinity,
        type: ButtonType = .normal,
        isDisabled: Bool = false
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.textColor = textColor
        self.font = font
        self.image = image
        self.imageRight = imageRight
        self.action = action
        self.cornerRadius = cornerRadius
        self.width = width
        self.type = type
        self.isDisabled = isDisabled
    }
    
    init(
        text: String? = nil,
        colorSet: ButtonColorSet,
        font: Font = .headlineEmphasized,
        image: String? = nil,
        imageRight: String? = nil,
        action: @escaping () -> Void,
        cornerRadius: CGFloat = 12,
        width: CGFloat = .infinity,
        type: ButtonType = .normal,
        isDisabled: Bool = false
    ) {
        self.init(
            text: text,
            backgroundColor: colorSet.backgroundColor,
            foregroundColor: colorSet.foregroundColor,
            textColor: colorSet.textColor,
            font: font,
            image: image,
            imageRight: imageRight,
            action: action,
            cornerRadius: cornerRadius,
            width: width,
            type: type,
            isDisabled: isDisabled
        )
    }
    
    var body: some View {
        let label = HStack(spacing: 8) {
            if let image = image {
                Image(systemName: image)
                    .font(font)
                    .foregroundStyle(isDisabled ? ButtonColorSet.disabled.textColor : textColor)
            }
            
            if let text = text, !text.isEmpty {
                Text(text)
                    .foregroundStyle(isDisabled ? ButtonColorSet.disabled.textColor : textColor)
                    .font(font)
            }
            
            if let imageRight = imageRight {
                Image(systemName: imageRight)
                    .font(font)
                    .foregroundStyle(isDisabled ? ButtonColorSet.disabled.textColor : textColor)
            }
        }
            .frame(maxWidth: .infinity)
        
        // Re-implemented ZStack from CustomButtonStyle
        ZStack {
            let currentBackgroundColor = isDisabled ? ButtonColorSet.disabled.backgroundColor : backgroundColor
            let currentForegroundColor = isDisabled ? ButtonColorSet.disabled.foregroundColor : foregroundColor
            let yOffset: CGFloat = 8
            
            buttonShape(color: currentBackgroundColor, foregroundColor: currentForegroundColor)
            
            buttonShape(color: currentForegroundColor, foregroundColor: currentForegroundColor)
                .offset(y: isPressed ? 0 : -yOffset)
            
            label
                .foregroundStyle(currentBackgroundColor)
                .offset(y: -yOffset)
                .offset(y: isPressed ? yOffset : 0)
        }
        .frame(maxWidth: width)
        .frame(height: 60)
        .padding(.horizontal, 2.5)
        .padding(.top, 2.5)
        .disabled(isDisabled)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if isDisabled { return }
                    isPressed = true
                }
                .onEnded { _ in
                    if isDisabled { return }
                    withAnimation(.default) {
                        isPressed = false
                    }
                    
                    SoundManager.shared.play(.buttonClick)
                    action()
                }
        )
    }
    
    @ViewBuilder
    private func buttonShape(color: Color, foregroundColor: Color) -> some View {
        let currentBackgroundColor = isDisabled ? ButtonColorSet.disabled.backgroundColor : self.backgroundColor
        
        switch self.type {
        case .normal:
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .fill(color)
        case .bordered:
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .fill(color)
                .overlay(
                    RoundedRectangle(cornerRadius: self.cornerRadius)
                        .stroke(currentBackgroundColor, lineWidth: 2.5)
                )
                .background(
                    RoundedRectangle(cornerRadius: self.cornerRadius + 2.5)
                        .fill(foregroundColor)
                )
                .padding(.horizontal, 2.5)
        }
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
                type: .normal
            )
            
            // Previous Button (has border)
            CustomButton(
                text: "Previous Button",
                colorSet: .normal,
                image: "arrow.left",
                action: {},
                type: .bordered
            )
            
            // Right Image Button
            CustomButton(
                text: "Next Button",
                colorSet: .normal,
                imageRight: "arrow.right",
                action: {},
                type: .bordered
            )
            
            // Icon-only Previous Button
            CustomButton(
                colorSet: .cancel,
                image: "arrow.left",
                action: {},
                width: 70,
                type: .bordered
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
