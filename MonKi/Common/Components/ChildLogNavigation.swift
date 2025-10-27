//
//  ChildLogNavigation.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import SwiftUI

// ini structnya dummy data
// TODO: di define ulang based on kebutuhan
struct ChildLogContent: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let color: Color
}

struct ChildLogNavigationView: View {
    @State private var currentIndex: Int = 0
    
    let pages: [ChildLogContent]
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            
            // MARK: - Progress Bar
            ProgressBar(
                count: Double(currentIndex + 1) / Double(pages.count),
                color: ColorPalette.orange500,
                action: onClose
            )
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
            
            // MARK: - Dynamic Content (Image + Text) could be replace
            VStack(spacing: 16) {
                Text(pages[currentIndex].title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(pages[currentIndex].subtitle)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Image(systemName: pages[currentIndex].imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 220)
                    .transition(.opacity.combined(with: .scale))
                    .padding(.top)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .animation(.easeInOut, value: currentIndex)
            
            Spacer()
            
            // MARK: - Navigation Buttons (Proportional Width)
            HStack(spacing: 12) {
                GeometryReader { geometry in
                    let totalWidth = geometry.size.width
                    
                    HStack(spacing: 12) {
                        if currentIndex > 0 {
                            CustomButton(
                                colorSet: .previous,
                                image: "arrow.left",
                                action: {
                                    withAnimation {
                                        currentIndex -= 1
                                    }
                                },
                                width: totalWidth * 0.33, // 1/3
                                type: .bordered,
                            )
                        }
                        CustomButton(
                            colorSet: .primary,
                            image: "arrow.right",
                            action: {
                                withAnimation {
                                    if currentIndex < pages.count - 1 {
                                        currentIndex += 1
                                    } else {
                                        onClose()
                                    }
                                }
                            },
                            width: currentIndex == 0 ? totalWidth : totalWidth * 0.67, // 2/3
                            type: .normal
                        )
                    }
                    .frame(width: totalWidth)
                }
                .frame(height: 60)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

#Preview {
    ChildLogNavigationView(
        pages: [
            ChildLogContent(title: "Headline 1", subtitle: "Lorem ipsum dolor sit amet", imageName: "checkmark", color: .orange),
            ChildLogContent(title: "Headline 2", subtitle: "Consectetur adipiscing elit", imageName: "xmark", color: .green),
            ChildLogContent(title: "Headline 3", subtitle: "Donec sit amet justo", imageName: "checkmark", color: .blue)
        ],
        onClose: { print("Onboarding closed") }
    )
}
