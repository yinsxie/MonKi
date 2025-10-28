//
//  ParentHomeView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 27/10/25.
//

import SwiftUI

struct ParentHomeView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel = ParentHomeViewModel()
    //    @State private var navigationPath = NavigationPath()
    
    // Grid layout: 2 columns
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    func didTapHomeButton() {
        print("Home Tapped")
        navigationManager.popToRoot()
    }
    func didTapPrevButton() { print("Previous Tapped") }
    func didTapNextButton() { print("Next Tapped") }
    
    var body: some View {
        //        NavigationStack(path: $navigationPath) {
        GeometryReader { geometry in
            
            // 1. ZStack for the static light gray background
            ZStack(alignment: .top) {
                
                // --- Static Background Layer (non-scrolling) ---
                ColorPalette.neutral50.ignoresSafeArea(.all)
                
                // 2. ScrollView for ALL content
                ScrollView {
                    
                    // 3. ZStack to layer the yellow circle BEHIND the content
                    // This entire ZStack will scroll
                    ZStack(alignment: .top) {
                        
                        // --- Scrolling Yellow Background ---
                        Circle()
                            .fill(ColorPalette.yellow300)
                        // Use the geometry from the outer GeometryReader
                            .offset(y: geometry.size.height / 3 )
                            .scaleEffect(3.0)
                        
                        // --- Scrolling Content VStack ---
                        VStack(spacing: 0) {
                            
                            // 4. Top Bar (Home Icon)
                            HStack {
                                CustomButton(
                                    backgroundColor: ColorPalette.yellow600,
                                    foregroundColor: ColorPalette.yellow400,
                                    textColor: ColorPalette.yellow50,
                                    font: .system(size: 20, weight: .black, design: .rounded),
                                    image: "house.fill",
                                    action: didTapHomeButton,
                                    cornerRadius: 24,
                                    width: 64,
                                    type: .normal
                                )
                                .frame(height: 70)
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                            
                            // 5. Header Text
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
                            
                            // 6. Card Area (Center content)
                            HStack(spacing: 40) {
                                // Left Arrow Button
                                CustomButton(
                                    backgroundColor: ColorPalette.yellow600,
                                    foregroundColor: ColorPalette.yellow400,
                                    textColor: ColorPalette.neutral50,
                                    font: .system(size: 20, weight: .black, design: .rounded),
                                    image: "arrow.left",
                                    action: didTapPrevButton,
                                    cornerRadius: 24,
                                    width: 72,
                                    type: .normal
                                )
                                
                                // Gray Placeholder Card
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(ColorPalette.neutral300)
                                    .frame(width: 125, height: 125)
                                
                                // Right Arrow Button
                                CustomButton(
                                    backgroundColor: ColorPalette.yellow600,
                                    foregroundColor: ColorPalette.yellow400,
                                    textColor: ColorPalette.neutral50,
                                    font: .system(size: 20, weight: .black, design: .rounded),
                                    image: "arrow.right",
                                    action: didTapNextButton,
                                    cornerRadius: 24,
                                    width: 72,
                                    type: .normal
                                )
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 60)
                            
                            // 7. Card Grid or Empty State
                            if viewModel.logsForParent.isEmpty {
                                VStack(spacing: 8) {
                                    Text("Masih kosong di sini~")
                                        .font(.title3Emphasized)
                                        .foregroundStyle(ColorPalette.neutral950)
                                    
                                    Text("Saat anak punya keinginan baru,\nParents bisa kasih pendapat di sini.")
                                        .font(.bodyRegular)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(ColorPalette.neutral950)
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 30)
                                .padding(.bottom, 100)
                                
                            } else {
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(viewModel.logsForParent) { log in
                                        ReviewCardView(log: log)
                                            .frame(height: 241)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 30)
                                .padding(.bottom, 100)
                            }
                        }
                    }
                }
                // Prevents the scroll view from going under the status bar
                .ignoresSafeArea(edges: .bottom)
            }
        }
        //        }
        .onAppear {
            viewModel.loadLogs()
        }
    }
}

// Xcode Preview
struct ParentHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ParentHomeView()
    }
}
