//
//  StoryPageView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 29/10/25.
//

import SwiftUI

struct StoryPageView: View {
    let page: ReflectionPage
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) { // Add spacing between title and cards
            
            // 1. Title/Subtitle Block
            VStack(alignment: .leading, spacing: 0) {
                Text(page.title)
                    .opacity(0.5)
                
                Text(page.subtitle)
            }
            .font(.largeTitleEmphasized)
            .foregroundStyle(ColorPalette.orange900)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // 2. ScrollView for the Cards
            VStack(spacing: 28) { // Spacing between cards
                ForEach(page.cards) { card in
                    ReflectionCardView(card: card)
                }
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    let previewPage = ReflectionPage(
        title: "#1",
        subtitle: "Tanya alasan di balik pilihan anak...",
        cards: [
            ReflectionCard(
                title: "Contoh pertanyaan:",
                mainTextPrefix: "“Mama/papa pengen tahu kenapa kamu ",
                mainTextHighlight: "merasa bahagia",
                mainTextSuffix: " kalau memiliki...”",
                highlightedText: nil,
                imageName: "icecream_placeholder"
            ),
            ReflectionCard(
                title: "Contoh pertanyaan:",
                mainTextPrefix: "“Mama/papa pengen tahu kenapa kamu ",
                mainTextHighlight: "merasa ini berguna",
                mainTextSuffix: " untuk”",
                highlightedText: "kesehatan",
                imageName: "icecream_placeholder"
            )
        ]
    )
    
    StoryPageView(page: previewPage)
        .padding(26) // Add padding to mimic the main view
        .background(ColorPalette.yellow500)
}
