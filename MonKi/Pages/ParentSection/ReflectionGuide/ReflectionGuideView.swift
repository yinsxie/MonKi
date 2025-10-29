//
//  ReflectionGuideView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 28/10/25.
//

import SwiftUI

struct ReflectionGuideView: View {
    
    let log: MsLog
    @StateObject private var viewModel: ReflectionGuideViewModel
    @EnvironmentObject var navigationManager: NavigationManager
    
    init(log: MsLog) {
        self.log = log
        _viewModel = StateObject(wrappedValue: ReflectionGuideViewModel(log: log))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                
                ColorPalette.neutral50.ignoresSafeArea(.all)
                
                Circle()
                    .fill(ColorPalette.yellow300)
                    .offset(y: geometry.size.height / 3 )
                    .scaleEffect(3.0)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .top)
                
                // 2. Main Content
                VStack(alignment: .leading, spacing: 24) {
                    
                    closeButton
                        .padding(.horizontal, 24)
                    
                    VStack(spacing: 12) {
                        Text("Pemahaman anak belum sesuai?")
                            .font(.title1Emphasized)
                            .foregroundStyle(ColorPalette.neutral950)
                        
                        Text("Jadikan momen ini buat diskusi bareng si kecil dan bantu dia memahami alasannya, ya!")
                            .font(.bodyRegular)
                            .foregroundStyle(ColorPalette.neutral700)
                    }
                    .padding(.horizontal, 26)
                    .multilineTextAlignment(.center)

                    Image("icecream_placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 224, height: 286)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(16)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer()
                }
                .padding(.top, 20)
                
                // 3. White Bottom Card
                HStack(spacing: 16) {
                    CustomButton(
                        text: "Nanti, deh!",
                        colorSet: .destructive,
                        font: .calloutEmphasized,
                        action: {
                            navigationManager.popLast()
                        },
                        cornerRadius: 24,
                        width: 115,
                        type: .normal
                    )
                    
                    CustomButton(
                        text: "Mulai Sekarang",
                        colorSet: .primary,
                        font: .calloutEmphasized,
                        imageRight: "arrow.right",
                        action: {
                            navigationManager.goTo(.parentHome(.reflectionGuideStory(log: log)))
                        },
                        cornerRadius: 24,
                        width: 187,
                        type: .normal
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: - Subviews
    
    private var closeButton: some View {
        CustomButton(
            backgroundColor: ColorPalette.yellow600,
            foregroundColor: ColorPalette.yellow400,
            textColor: ColorPalette.yellow50,
            font: .system(size: 20, weight: .black, design: .rounded),
            image: "house.fill",
            action: navigationManager.popLast,
            cornerRadius: 24,
            width: 64,
            type: .normal
        )
        .frame(height: 70)
    }
    
}
