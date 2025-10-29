//
//  SelectModePage.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import SwiftUI

struct SelectModePage: View {
    @Binding var selectedMode: String?
    @Binding var isGalleryPermissionGranted: Bool
    @ObservedObject var viewModel: ChildLogViewModel
    
    var body: some View {
        VStack {
            // MARK: - Bagian Atas: Teks
            Text("Yuk, tunjukkin impianmu!")
                .font(Font.title2Emphasized)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            // MARK: - Bagian Tengah: Card
            HStack(spacing: 16) {
                ChildInputCard(
                    text: "Draw",
                    isSelected: selectedMode == "Draw"
                ) {
                    selectedMode = "Draw"
                }
                
                ChildInputCard(
                    text: "Gallery",
                    isSelected: selectedMode == "Gallery"
                ) {
                    selectedMode = "Gallery"
                }
            }
            .animation(.easeInOut, value: selectedMode)
            .padding(.horizontal, 32)
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .padding(.vertical, 140)
    }
}
