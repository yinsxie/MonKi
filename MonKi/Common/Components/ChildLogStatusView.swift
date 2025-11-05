//
//  ChildLogStatusView.swift
//  MonKi
//
//  Created by William on 04/11/25.
//

import SwiftUI

enum StatusTagType {
    case noTag
    case firstTag
    case secondTag
    
    var backgroundColor: Color {
        switch self {
        case .noTag:
            return ColorPalette.neutral200
        case .firstTag:
            return Color(hex: "#BEDB41")
        case .secondTag:
            return Color(hex: "#92C1FE")
        }
    }
    
    var textColor: Color {
        switch self {
        case .noTag:
            return ColorPalette.neutral500
        case .firstTag:
            return Color(hex: "#5C7100")
        case .secondTag:
            return Color(hex: "#396AA8")
        }
    }
}

struct ChildLogStatusView: View {
    
    let happyLevel: HappyLevelEnum
    let firstTagTitle: String?
    let secondTagTitle: String?
    let childLogStatusBubble: String = "ChildLogStatusBubble"
    let childLogStatusBubbleEmpty: String = "ChildLogStatusBubbleEmpty"
    let childLogStatusMonkiEmpty: String = "ChildLogStatusMonkiEmpty"
    let isEmpty: Bool
    
    init(happyLevel: HappyLevelEnum, firstTagTitle: String?, secondTagTitle: String?) {
        self.happyLevel = happyLevel
        self.firstTagTitle = firstTagTitle
        self.secondTagTitle = secondTagTitle
        self.isEmpty = false
    }
    
    init(isEmpty: Bool) {
        self.isEmpty = isEmpty
        self.happyLevel = .init(level: 0)
        self.firstTagTitle = nil
        self.secondTagTitle = nil
    }
    
    var body: some View {
        ZStack {
            
            Image(isEmpty ? childLogStatusMonkiEmpty : happyLevel.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 75)
                .offset(y: -58)
            
            ZStack {
                Image(isEmpty ? childLogStatusBubbleEmpty : childLogStatusBubble)
                    .resizable()
                    .scaledToFit()
                
                if !isEmpty {
                    VStack(spacing: 4) {
                        if firstTagTitle == nil && secondTagTitle == nil {
                            tagBuilder(withText: "-", ofType: .noTag)
                        } else {
                            if let firstTagTitle = firstTagTitle {
                                tagBuilder(withText: firstTagTitle, ofType: .firstTag)
                            }
                            
                            if let secondTagTitle = secondTagTitle {
                                tagBuilder(withText: secondTagTitle, ofType: .secondTag)
                            }
                        }
                    }
                }
                
                if isEmpty {
                    VStack (spacing: 4) {
                        emptyTag
                        emptyTag
                    }
                }
            }
            .frame(width: 95)
        }
    }
    
    var emptyTag: some View {
        tagBuilder(withText: "?", ofType: .noTag)
    }
    
    @ViewBuilder
    func tagBuilder(withText text: String, ofType color: StatusTagType) -> some View {
        Text(text)
            .foregroundStyle(color.textColor)
            .font(.caption2Semibold)
            .padding(.horizontal, 13)
            .padding(.vertical, 5)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 8).fill(color.backgroundColor))
            .padding(.horizontal, 7)
        
    }
}

#Preview {
    VStack(spacing: 50) {
        ChildLogStatusView(happyLevel: .level1, firstTagTitle: "test", secondTagTitle: "Test1fffff")
        
        ChildLogStatusView(happyLevel: .level1, firstTagTitle: "Test1fffff", secondTagTitle: nil)
        
        ChildLogStatusView(happyLevel: .level1, firstTagTitle: nil, secondTagTitle: nil)
        
        ChildLogStatusView(isEmpty: true)
    }
}
