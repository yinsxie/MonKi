//
//  ChildInputCard.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import SwiftUI

struct ChildInputCard: View {
    let text: String?
    let image: String
    let isSelected: Bool
    let cornerRadius: CGFloat
    let padding: CGFloat
    let action: () -> Void
    
    init(
        text: String? = nil,
        image: String,
        isSelected: Bool,
        cornerRadius: CGFloat = 20,
        padding: CGFloat = 16,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.image = image
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.action = action
    }
    
    var body: some View {
        let colorSet: ButtonColorSet = isSelected ? .cancel : .previous
        let type: CustomButtonStyle.Shape = .borderedRectangle
        
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        } label: {
            VStack(spacing: 16) {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: UIScreen.main.bounds.height * 0.15)
                
                if let safeText = text {
                    Text(safeText)
                        .font(Font.title3Emphasized)
                        .foregroundStyle(colorSet.textColor)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(padding)
        }
        .buttonStyle(CustomButtonStyle(
            backgroundColor: colorSet.backgroundColor,
            foregroundColor: colorSet.foregroundColor,
            cornerRadius: cornerRadius,
            shape: type
        ))
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.3)
    }
}
