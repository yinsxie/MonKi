//
//  ReviseLogHowHappyView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 01/11/25.
//

import SwiftUI

/// This is a copy of 'HowHappyView', but adapted for 'ReLogViewModel'.
struct ReLogHowHappyView: View {
    @ObservedObject var viewModel: ReLogViewModel // <-- Changed
    
    var body: some View {
        // This 'body' is copied *exactly* from your HowHappyView.swift
        VStack(alignment: .center, spacing: 0) {
            // MARK: - Bagian Atas: Teks
            Text("Perasaanmu tentang barang itu gimana?")
                .font(Font.title2Emphasized)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 40)
            
            // MARK: - Gambar Monki
            Image(viewModel.monkiImageName)
                .resizable()
                .scaledToFit()
//                .frame(height: 200, alignment: .top)
                .padding(.bottom, 40)
            
            // MARK: - Pilihan Emote
            CustomSlider(
                value: $viewModel.happyLevel,
                image: viewModel.sliderImage
            )
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .padding(.vertical, 140)
//        .padding(.horizontal, 24)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                AudioManager.shared.play("HowHappy")
            }
        }
    }
}
