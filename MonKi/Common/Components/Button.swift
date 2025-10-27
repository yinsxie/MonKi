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
    let colorSet: ButtonColorSet
    let image: String?
    let action: () -> Void
    let cornerRadius: CGFloat
    let width: CGFloat
    let type: ButtonType
    
    init(
        text: String? = nil,
        colorSet: ButtonColorSet,
        image: String? = nil,
        action: @escaping () -> Void,
        cornerRadius: CGFloat = 12,
        width: CGFloat = .infinity,
        type: ButtonType = .normal
    ) {
        self.text = text
        self.colorSet = colorSet
        self.image = image
        self.action = action
        self.cornerRadius = cornerRadius
        self.width = width
        self.type = type
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let image = image {
                    Image(systemName: image)
                        .imageScale(.large)
                        .foregroundStyle(colorSet.textColor)
                }
                
                if let text = text, !text.isEmpty {
                    Text(text)
                        .foregroundStyle(colorSet.textColor)
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity)
            
        }
        .buttonStyle(CustomButtonStyle(
            backgroundColor: colorSet.backgroundColor,
            foregroundColor: colorSet.foregroundColor,
            cornerRadius: cornerRadius,
            shape: type == .normal ? .rectangle : .borderedRectangle
            
        ))
        .frame(width: width, height: 60)
        .padding(.horizontal, 2.5)
        .padding(.top, 2.5)
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
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
