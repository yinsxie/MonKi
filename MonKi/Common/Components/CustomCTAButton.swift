//
//  FieldCustonButton.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

import SwiftUI

struct CustomCTAButton: View {
    enum ButtonType {
        case normal
        case bordered
    }
    
    let text: String
    let backgroundColor: Color
    let foregroundColor: Color
    let textColor: Color
    let font: Font
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let imageRight: String?
    let cornerRadius: CGFloat
    let action: () -> Void
    
    init(
        text: String,
        backgroundColor: Color = ColorPalette.blue200,
        foregroundColor: Color = ColorPalette.blue100,
        textColor: Color = ColorPalette.blue700,
        font: Font = .footnoteEmphasized,
        horizontalPadding: CGFloat = 16,
        verticalPadding: CGFloat = 12,
        imageRight: String? = nil,
        cornerRadius: CGFloat = 20,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.textColor = textColor
        self.font = font
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.imageRight = imageRight
        self.action = action
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(text)
                    .foregroundStyle(textColor)
                    .font(font)
                
                if let image = imageRight {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(textColor)
                        .frame(height: 24)
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
        }
        .buttonStyle(CustomButtonStyle(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            cornerRadius: cornerRadius,
            shape: .rectangle
            
        ))
        .fixedSize()
        .contentShape(Rectangle())
        
    }
}

#Preview {
    VStack(spacing: 20) {
        if let img = FieldState.approved.CTAButtonImage {
            CustomCTAButton(
                text: "Siram",
                imageRight: img) {
                
            }
        }
        
    }
    .padding()
}
