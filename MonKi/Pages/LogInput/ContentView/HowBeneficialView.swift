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
            Text("Perasaanmu tentang barang itu gimana?")
                .font(Font.title2Emphasized)
                .multilineTextAlignment(.center)
//                .padding(.bottom, 40)
            
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

#Preview {
    let previewContext = CoreDataManager.shared.viewContext
    let viewModel = ChildLogViewModel(context: previewContext)
    
    HowBeneficialView(viewModel: viewModel)
        .environment(\.managedObjectContext, previewContext)
}
