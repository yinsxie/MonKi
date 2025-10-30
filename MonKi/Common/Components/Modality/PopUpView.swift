//
//  PopUpView.swift
//  MonKi
//
//  Created by William on 30/10/25.
//

import SwiftUI

struct PopUpView: View {
    
    let type: PopUpModalityProtocol
    var onCancel: (() -> Void)?
    
    var body: some View {
        ZStack {
            ColorPalette.neutral800.opacity(0.5)
                .ignoresSafeArea()
                .animation(nil, value: false)
                .zIndex(0)
            
            VStack(spacing: 24) {
                cancelButton
                
                popUpHeader
                
                buttonsSection
            }
            .padding(24)
            .background(RoundedRectangle(cornerRadius: 24).fill(ColorPalette.pink50))
            .padding(.horizontal, 36)
            .zIndex(1)
            
        }
    }
    
    var buttonsSection: some View {
        VStack(spacing: 20) {
            if type.primaryButtonTitle != nil {
                CustomButton(
                    text: type.primaryButtonTitle,
                    colorSet: .primary,
                    action: type.onPrimaryButtonTap ?? {},
                    cornerRadius: 24,
                    type: .normal,
                )
            }
            
            if type.secondaryButtonTitle != nil {
                CustomButton(
                    text: type.secondaryButtonTitle,
                    colorSet: .cancel,
                    action: type.onSecondaryButtonTap ?? {},
                    cornerRadius: 24,
                    type: .normal,
                )
            }
        }
    }
    
    var popUpHeader: some View {
        VStack(spacing: 10) {
            Image(type.imageIcon.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 186)
            
            Text(type.title)
                .font(.title3Emphasized)
                .multilineTextAlignment(.center)
            
            if let subtitle = type.subtitle {
                Text(subtitle)
                    .font(.bodyRegular)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(ColorPalette.neutral700)
            }
        }
    }
    
    var cancelButton: some View {
        HStack {
            CustomButton(
                colorSet: .destructive,
                font: .system(size: 20, weight: .black, design: .rounded),
                image: "xmark",
                action: {
                    onCancel?()
                },
                cornerRadius: 24,
                width: 64,
                type: .normal
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        
    }
}

#Preview {
    ZStack {
        Text("Test")
        
        PopUpView(type: ParentSectionModalType.onStoryViewCancelButtonTapped())
        
    }
}
