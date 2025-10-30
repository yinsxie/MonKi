//
//  HowHappyView.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 30/10/25.
//

import SwiftUI

struct HowHappyView: View {
    @Binding var selectedMode: String?
    @ObservedObject var viewModel: ChildLogViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0){
            // MARK: - Bagian Atas: Teks
            Text("Perasaanmu tentang barang itu gimana?")
                .font(Font.title2Emphasized)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 40)
            
            // MARK: - Gambar Monki
            Image("MonkiInputPlaceholder")
                .resizable()
                .scaledToFit()
                .frame(height: 200, alignment: .top)
                .padding(.bottom, 40)
            
            // MARK: - Pilihan Emote
            HStack(alignment: .top, spacing: 8) {
                ChildInputCard(
                    image: "EmoteLove",
                    isSelected: selectedMode == "Happy",
                    width: .infinity,
                ) {
                    selectedMode = "Happy"
                }
                
                ChildInputCard(
                    image: "EmoteBiasa",
                    isSelected: selectedMode == "Biasa",
                    width: .infinity,
                ) {
                    selectedMode = "Biasa"
                }
            }
            .frame(height: 160, alignment: .top)
            .frame(maxWidth: .infinity)
            .animation(.easeInOut, value: selectedMode)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .padding(.vertical, 140)
        .padding(.horizontal, 24)
    }
}
