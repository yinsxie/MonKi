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
            Spacer()
            
            // MARK: - Bagian Atas: Teks
            Text("Yuk, tunjukkin impianmu!")
                .font(Font.title2Emphasized)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40)
            
            // MARK: - Bagian Tengah: Card
            HStack(spacing: 8) {
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
            .frame(height: 400, alignment: .top)
            .frame(maxWidth: .infinity)
            .animation(.easeInOut, value: selectedMode)
            .padding(.horizontal)
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .padding(.vertical, 140)
    }
}
