//
//  ParentHomeView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 27/10/25.
//

import SwiftUI

struct ParentHomeView: View {
    
    // Actions for the placeholder buttons
    func didTapHomeButton() { print("Home Tapped") }
    func didTapPrevButton() { print("Previous Tapped") }
    func didTapNextButton() { print("Next Tapped") }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            // 1. ZStack to layer the yellow background below the content
            ZStack(alignment: .top) {
                
                // --- Background Layer ---
                ColorPalette.neutral50.ignoresSafeArea(.all)
                
                // 2. Yellow Background Shape (The giant circle)
                // We use ZStack with alignment .top so the GeometryReader's height (geometry.size.height)
                // is the reference point for calculating the vertical offset.
                Group {
                    Circle()
                        .fill(ColorPalette.yellow300)
                    //  .frame(width: 1200, height: 1200)
                        .offset(y: geometry.size.height / 3 )
                        .scaleEffect(3.0)

                }
                .ignoresSafeArea(.all, edges: .bottom)
                
                VStack(spacing: 0) {
                    
                    // 3. Top Bar (Home Icon)
                    HStack {
                        // Home Button (Icon-only)
                        CustomButton(
                            colorSet: .normal,
                            image: "house.fill",
                            action: didTapHomeButton,
                            cornerRadius: 24,
                            width: 64,
                            type: .normal
                        )
                        .frame(height: 70)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // 4. Header Text
                    VStack(spacing: 12) {
                        Text("Hi, Parents!")
                            .font(.title1Emphasized)
                            .foregroundStyle(ColorPalette.neutral950)
                        
                        Text("Waktunya kasih pendapat apakah pilihan anak udah sesuai sama nilai keluarga?")
                            .font(.bodyRegular)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(ColorPalette.neutral700)
                            .padding(.horizontal, 32)
                    }
                    .padding(.top, 20)
                    
                    // 5. Card Area (Center content)
                    Spacer()
                    
                    HStack(spacing: 16) {
                        
                        // Left Arrow Button
                        CustomButton(
                            colorSet: .normal,
                            image: "arrow.left",
                            action: didTapPrevButton,
                            cornerRadius: 24,
                            width: 72,
                            type: .normal
                        )
                        .frame(height: 70)
                        
                        // Gray Placeholder Card
                        RoundedRectangle(cornerRadius: 16)
                            .fill(ColorPalette.neutral300)
                            .frame(width: 125, height: 125)
                        
                        // Right Arrow Button
                        CustomButton(
                            colorSet: .normal,
                            image: "arrow.right",
                            action: didTapNextButton,
                            cornerRadius: 24,
                            width: 72,
                            type: .normal
                        )
                        .frame(height: 70)
                        
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer() // Spacer to push bottom text down
                    
                    // 6. Bottom Text on Yellow Background
                    VStack(spacing: 8) {
                        Text("Masih kosong di sini~")
                            .font(.title3Emphasized)
                            .foregroundStyle(ColorPalette.neutral950)
                        
                        Text("Saat anak punya keinginan baru,\nParents bisa kasih pendapat di sini.")
                            .font(.bodyRegular)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(ColorPalette.neutral950)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 60)
                    .padding(.top, 30) // Add top padding to move it slightly down from the card
                    // This Vstack is now visible because the main content Vstack is now working
                    
                    Spacer()
                    
                } // End of Content VStack
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

// Xcode Preview
struct ParentHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ParentHomeView()
    }
}
