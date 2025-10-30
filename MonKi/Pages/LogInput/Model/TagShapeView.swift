//
//  TagShapeView.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 29/10/25.
//

import SwiftUI

// MARK: - 2. Single Tag Component
struct TagShapeView: View {
    
    let tag: BeneficialTag
    let text: String
    
    let isSelected: Bool
    let isSelectionLocked: Bool
    
    private var state: TagDisplayState {
        if isSelected {
            return .selected
        } else if isSelectionLocked {
            return .unselected
        } else {
            return .active
        }
    }
    
    var body: some View {
        let currentState = state
        let currentImageName = tag.assetName(for: currentState)
        let currentTextColor = getTextColor(for: currentState)
        
        ZStack {
            Image(currentImageName)
                .resizable()
                .scaledToFit()
            
            Text(text)
                .font(Font.title3Semibold)
                .foregroundColor(currentTextColor)
        }
        .frame(height: 150)
        .animation(.easeInOut(duration: 0.2), value: currentState)
    }
    
    private func getTextColor(for state: TagDisplayState) -> Color {
        switch state {
        case .active, .selected:
            return tag.textColor
        case .unselected:
            return ColorPalette.neutral400
        }
    }
}
