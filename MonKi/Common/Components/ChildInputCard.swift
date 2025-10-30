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
    let width: CGFloat
    let action: () -> Void
    
    init(
        text: String? = nil,
        image: String,
        isSelected: Bool,
        cornerRadius: CGFloat = 20,
        width: CGFloat = 160,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.image = image
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
        self.width = width
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
            .padding(16)
        }
        .buttonStyle(CustomButtonStyle(
            backgroundColor: colorSet.backgroundColor,
            foregroundColor: colorSet.foregroundColor,
            cornerRadius: cornerRadius,
            shape: type
        ))
        .frame(
            width: width,
            height: UIScreen.main.bounds.height * 0.3
        )
        .frame(maxWidth: width == .infinity ? .infinity : nil)
    }
}
