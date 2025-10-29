//
//  FieldCustonButton.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

import SwiftUI

struct FieldCustomButton: View {
    enum ButtonType {
        case normal
        case bordered
    }
    
    let text: String
    let backgroundColor: Color
    let foregroundColor: Color
    let textColor: Color
    let font: Font
    let imageRight: String
    let cornerRadius: CGFloat
    let action: () -> Void
    
    init(
        text: String,
        backgroundColor: Color = ColorPalette.blue200,
        foregroundColor: Color = ColorPalette.blue100,
        textColor: Color = ColorPalette.blue700,
        font: Font = .footnoteEmphasized,
        imageRight: String,
        cornerRadius: CGFloat = 20,
        action: @escaping () -> Void,
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.textColor = textColor
        self.font = font
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
                
                Image(imageRight)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(textColor)
                    .frame(height: 24)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
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
            FieldCustomButton(
                text: "Siram",
                imageRight: img) {
                
            }
        }
        
    }
    .padding()
}
