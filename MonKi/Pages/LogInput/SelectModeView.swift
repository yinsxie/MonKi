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
    let viewModel: ChildLogViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // MARK: - Bagian Atas: Teks
            VStack(spacing: 12) {
                Text("Headilne")
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Lorem ipsum dolor sit amet")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 24)
            
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
                    if !isGalleryPermissionGranted {
                        viewModel.requestGalleryPermission { _ in }
                    }
                }
            }
            .animation(.easeInOut, value: selectedMode)
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}
