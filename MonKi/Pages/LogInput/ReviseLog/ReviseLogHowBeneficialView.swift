//
//  ReviseLogHowBeneficialView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 01/11/25.
//

import SwiftUI

/// This is a copy of 'HowBeneficialView', but adapted for 'ReLogViewModel'.
struct ReLogHowBeneficialView: View {
    @ObservedObject var viewModel: ReLogViewModel // <-- Changed
    
    var body: some View {
        // This 'body' is copied *exactly* from your HowBeneficialView.swift
        VStack {
            
            // MARK: - Bagian Atas: Teks
            Text("Perasaanmu tentang barang itu gimana?")
                .font(Font.title2Emphasized)
                .multilineTextAlignment(.center)
//                .padding(.bottom, 40)
            
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
    }
}
