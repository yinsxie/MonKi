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
        VStack(alignment: .center, spacing: 0) {
            // MARK: - Bagian Atas: Teks
            Text("Yuk, tunjukkin impianmu!")
                .font(Font.title2Emphasized)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40)
            
            // MARK: - Bagian Tengah: Card
            HStack(alignment: .top, spacing: 8) {
                ChildInputCard(
                    text: "Draw",
                    image: "MonkiDraw",
                    isSelected: selectedMode == "Draw",
                    width: .infinity
                ) {
                    selectedMode = "Draw"
                }
                
                ChildInputCard(
                    text: "Gallery",
                    image: "MonkiPhoto",
                    isSelected: selectedMode == "Gallery",
                    width: .infinity
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
