//
//  ParentReviewRejectView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 01/11/25.
//

import SwiftUI

struct ParentReviewRejectView: View {
    
    let log: MsLog
    @EnvironmentObject var navigationManager: NavigationManager
    
    init(log: MsLog) {
        self.log = log
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ColorPalette.yellow50.ignoresSafeArea(.all)
            
            Image("RejectBackground")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(.container, edges: .bottom)
            
            // 2. Main Content
            VStack(alignment: .leading, spacing: 24) {
                
                closeButton
                    .padding(.horizontal, 24)
                
                VStack(spacing: 12) {
                    Text("Apapun keputusan Parents, bisa bantu anak belajar!")
                        .font(.title2Emphasized)
                        .foregroundStyle(ColorPalette.neutral950)
                    
                    Text("Sekarang waktunya si kecil lanjut menanam kebijaksanaan")
                        .font(.bodyRegular)
                        .foregroundStyle(ColorPalette.neutral700)
                }
                .padding(.horizontal, 50)
                .multilineTextAlignment(.center)
                
                if let imagePath = log.imagePath, let uiImage = ImageStorage.loadImage(from: imagePath) {
                    ZStack {
                        Image("ThoughtBubbleApproved")
                            .resizable()
                            .scaledToFill()
                        
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .padding(.leading, 25)
                            .padding(.trailing, 30)
                            .padding(.top, 30)
                            .padding(.bottom, 70)
                    }
                    .frame(width: 160, height: 180)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .offset(x: -100, y: 0)
                }
                
                Spacer()
            }
            .padding(.top, 20)
            
            CustomButton(
                text: "Log Ulang",
                colorSet: .primary,
                font: .calloutEmphasized,
                action: {
                    navigationManager.popToFlowRoot()
                },
                cornerRadius: 24,
                width: 120,
                type: .normal
            )
            .padding(.bottom, 36)
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Subviews
    
    private var closeButton: some View {
        CustomButton(
            backgroundColor: ColorPalette.yellow600,
            foregroundColor: ColorPalette.yellow400,
            textColor: ColorPalette.yellow50,
            font: .system(size: 20, weight: .black, design: .rounded),
            image: "house.fill",
            action: navigationManager.popToFlowRoot,
            cornerRadius: 24,
            width: 64,
            type: .normal
        )
        .frame(height: 70)
    }
    
}

// MARK: - Preview

struct ParentReviewRejectView_Previews: PreviewProvider {
    static var mockLog: MsLog {
        let context = CoreDataManager.shared.viewContext
        let log = MsLog(context: context)
        log.id = UUID()
        log.state = "created"
        log.imagePath = "icecream_placeholder"
        
        return log
    }
    
    static var previews: some View {
        ParentReviewRejectView(log: mockLog)
            .environmentObject(NavigationManager())
    }
}
