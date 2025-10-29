//
//  FieldCardView.swift
//  MonKi
//
//  Created by William on 29/10/25.
//
import SwiftUI

struct FieldCardView: View {
    
    //    var msLog: MsLog
    var type: FieldState
    var logImage: UIImage?
    
    var onEmptyFieldTapped: (() -> Void)?
    var onCTAButtonTapped: (() -> Void)?
    
    let emptyFieldSize: CGFloat = 141.0
    let widthAndPotField: CGFloat = 130.0
    
    var heightPot: CGFloat {
        switch type {
        case .empty:
            return widthAndPotField
        case .created:
            return 158.59
        case .approved, .done:
            return 181.71
        case .needToTalk, .declined:
            return 158.59
        }
    }
    
    var heightField: CGFloat = 181.71
    
    init(
        type: FieldState,
        logImage: UIImage? = UIImage(named: ColoredPencilAsset.canvasViewBlackPencil.imageName),
        onEmptyFieldTapped: (() -> Void)? = nil,
        onCTAButtonTapped: (() -> Void)? = nil
    ) {
        self.type = type
        self.logImage = logImage
        self.onEmptyFieldTapped = onEmptyFieldTapped
        self.onCTAButtonTapped = onCTAButtonTapped
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            if type != .empty, let fieldAsset = type.fieldAsset {
                Image(fieldAsset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: widthAndPotField, height: heightPot, alignment: .center)
                    .offset(y: -60 + (type == .done ? -23.12/2 : 0))
                
            }
            
            if
                type != .empty,
                let thoughtBubbleImage = type.thoughtBubbleImage,
                let img = logImage {
                ZStack {
                    Image(thoughtBubbleImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 71, height: 71)
                    
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 28)
                        .offset(y: -4)
                }
                .offset(x: -50, y: -55)
                
            }
            
            if let CTATitle = type.CTAButtonTitle, let CTAButtonImage = type.CTAButtonImage {
                FieldCustomButton(
                    text: CTATitle,
                    imageRight: CTAButtonImage, action: onCTAButtonTapped ?? {})
                .offset(y: 130)
            }
        }
        .background(
            Image(GardenImageAsset.gardenEmptyField.imageName)
                .resizable()
                .frame(width: emptyFieldSize, height: emptyFieldSize)
                .onTapGesture {
                    if type == .empty {
                        onEmptyFieldTapped?()
                    }
                }
        )
        .frame(width: widthAndPotField, height: heightField)
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 70) {
        FieldCardView(type: .empty)
        FieldCardView(type: .approved)
        FieldCardView(type: .created)
        FieldCardView(type: .done)
        
    }
    .padding(.top, 50)
    .frame(maxWidth: .infinity)
}
