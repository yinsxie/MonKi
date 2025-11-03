//
//  HowBeneficialView.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 30/10/25.
//

import SwiftUI

struct HowBeneficialView: View {
    @ObservedObject var viewModel: ChildLogViewModel
    
    var body: some View {
        VStack {
            
            // MARK: - Bagian Atas: Teks
            Text("Menurut kamu, itu berguna buat apa?")
                .font(Font.title2Emphasized)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            // MARK: - Bagian Tengah: Card
            TagSelectionPageView(
                tagTexts: viewModel.beneficialTagLabels,
                selectedTags: $viewModel.selectedBeneficialTags
            )
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .padding(.vertical, 140)
        .onAppear {
            AudioManager.shared.stop()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                AudioManager.shared.play("HowBeneficial")
            }
        }
        .onDisappear {
            AudioManager.shared.stop()
        }
    }
}
