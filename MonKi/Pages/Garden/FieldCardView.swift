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
    var isShovelMode: Bool?
    var emptyStateColor: Color?
    
    var onFieldTapped: (() -> Void)?
    var onCTAButtonTapped: (() -> Void)?
    
    let emptyFieldSize: CGFloat = 141.0
    let widthAndPotField: CGFloat = 130.0
    
    var isShowCTAButton: Bool
    
    var heightPot: CGFloat {
        switch type {
        case .empty:
            return widthAndPotField
        case .created, .declined, .approved, .waiting:
            return 158.59
        case .done:
            return 181.71
        }
    }
    
    var heightField: CGFloat = 181.71
    
    init(
        type: FieldState,
        logImage: UIImage? = UIImage(named: ColoredPencilAsset.canvasViewBlackPencil.imageName),
        isShovelMode: Bool? = false,
        emptyStateColor: Color? = nil,
        onFieldTapped: (() -> Void)? = nil,
        onCTAButtonTapped: (() -> Void)? = nil
    ) {
        self.type = type
        self.logImage = logImage
        self.isShovelMode = isShovelMode
        self.emptyStateColor = emptyStateColor
        self.onFieldTapped = onFieldTapped
        self.onCTAButtonTapped = onCTAButtonTapped
        
        switch type {
        case .approved, .done:
            self.isShowCTAButton = true
        case .declined:
            self.isShowCTAButton = !(isShovelMode ?? true)
        case .created:
            self.isShowCTAButton = isShovelMode ?? true
        default:
            self.isShowCTAButton = true
        }
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
            
            if isShowCTAButton ,let CTATitle = type.CTAButtonTitle, let CTAButtonImage = type.CTAButtonImage {
                CustomCTAButton(
                    text: CTATitle,
                    backgroundColor: type.CTAButtonColor.1,
                    foregroundColor: type.CTAButtonColor.0,
                    imageRight: CTAButtonImage, action: onCTAButtonTapped ?? {})
                .offset(y: 130)
            }
        }
        .background(
            emptyStateBackgroundView
        )
        .frame(width: widthAndPotField, height: heightField)
        .onTapGesture {
            //MARK: ini sementara aja since garden akan berubah
                onFieldTapped?()
        }
    }
    
    @ViewBuilder
        private var emptyStateBackgroundView: some View {
        if type == .empty {
            ZStack {
                Image(GardenImageAsset.emptyFieldBase.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: emptyFieldSize, height: emptyFieldSize)
                    .foregroundStyle(emptyStateColor ?? Color(hex: "#AD7151")
)
                
                Image(GardenImageAsset.emptyFieldOverlay.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: emptyFieldSize, height: emptyFieldSize)
            }
            
        } else {
            Image(GardenImageAsset.gardenEmptyField.imageName)
                .resizable()
                .frame(width: emptyFieldSize, height: emptyFieldSize)
        }
    }
}

#Preview {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 70) {
        FieldCardView(type: .empty)
        FieldCardView(type: .created)
        FieldCardView(type: .waiting)
        FieldCardView(type: .approved)
        
    }
    .padding(.top, 50)
    .frame(maxWidth: .infinity)
}
