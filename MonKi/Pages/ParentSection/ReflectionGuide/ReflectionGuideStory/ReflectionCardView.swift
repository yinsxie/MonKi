//
//  ReflectionCardView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 29/10/25.
//

import SwiftUI

struct ReflectionCardView: View {
    
    let card: ReflectionCard
    
    private let cardTitleColor = Color.black.opacity(0.6)
    private let cardTextColor = Color.black
    private let checkerColor = Color.black.opacity(0.05)
    
    private let shadowLayerColor = ColorPalette.orange700
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 0) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text(card.title)
                    .font(.caption1Medium)
                    .foregroundStyle(.black)
                
                (
                    Text(card.mainTextPrefix)
                    +
                    Text(card.mainTextHighlight)
                        .bold()
                        .foregroundStyle(ColorPalette.orange600)
                    +
                    Text(card.mainTextSuffix)
                )
                .font(.bodySemibold)
                .foregroundStyle(.black)
                
                if let highlightedText = card.highlightedText {
                    Text(highlightedText)
                        .font(.title3Emphasized)
                        .foregroundStyle(ColorPalette.orange600)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 6)
                        .background(ColorPalette.orange100)
                        .cornerRadius(24)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                Circle()
                    .fill(ColorPalette.pink100)
                    .frame(width: 60, height: 60)
                
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            .frame(width: 60, height: 90)
        }
        .padding(.vertical, 24)
        .padding(.leading, 24)
        .padding(.trailing, 12)
        
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(shadowLayerColor)
                    .offset(x: 0, y: 12)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
            }
        )
        
    }
}

#Preview {
    VStack(spacing: 28) {
        ReflectionCardView(
            card: ReflectionCard(
                title: "Contoh pertanyaan:",
                mainTextPrefix: "“Mama/papa pengen tahu kenapa kamu ",
                mainTextHighlight: "merasa bahagia",
                mainTextSuffix: " kalau memiliki...",
                highlightedText: nil,
                imageName: "icecream_placeholder"
            )
        )
        
        ReflectionCardView(
            card: ReflectionCard(
                title: "Contoh pertanyaan:",
                mainTextPrefix: "“Mama/papa pengen tahu kenapa kamu ",
                mainTextHighlight: "merasa ini berguna",
                mainTextSuffix: " untuk",
                highlightedText: "kesehatan",
                imageName: "icecream_placeholder"
            )
        )
    }
    .padding()
    .background(ColorPalette.yellow500)
}
