//
//  HowHappyView.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 30/10/25.
//

import SwiftUI

struct HowHappyView: View {
    @ObservedObject var viewModel: ChildLogViewModel

    var body: some View {
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
//                .frame(height: 180, alignment: .top)
                .padding(.bottom, 40)
            
            // MARK: - Pilihan Emote (Slider)
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
        .onDisappear {
            AudioManager.shared.stop()
        }
    }
}
