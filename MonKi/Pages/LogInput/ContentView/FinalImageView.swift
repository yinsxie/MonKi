//
//  FinalImagePage.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import SwiftUI

struct FinalImagePage: View {
    let processedImage: UIImage?
    
    var body: some View {
        ZStack {
            // MARK: - Background: FinalImage
            Image("FinalImage")
                .resizable()
                .scaledToFit()
            
            // MARK: - Foreground: Gambar Hasil + Shadow
            VStack {
                if let image = processedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 300)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                        .padding()
                } else {
                    Image(systemName: "hand.thumbsup.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                }
            }
            .zIndex(1)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}

// MARK: - Preview
#Preview {
    FinalImagePage(processedImage: nil)
}
