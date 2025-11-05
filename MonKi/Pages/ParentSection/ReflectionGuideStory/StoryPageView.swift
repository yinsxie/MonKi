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
            VStack(alignment: .leading, spacing: 24) {
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(page.title)
                        .opacity(0.5)
                    
                    Text(page.subtitle)
                }
                .font(.largeTitleEmphasized)
                .foregroundStyle(ColorPalette.orange900)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(page.text)
                    .font(.title3Semibold)
                    .foregroundStyle(ColorPalette.orange900)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .top)
                    .padding(.top, 100)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    let previewPage = ReflectionPage(
        title: "#1",
        subtitle: "Tanya alasan di balik pilihan anak...",
        text: "“Mama/Papa ingin tahu kenapa barang ini bikin merasa bahagia dan merasa barang ini berguna untuk...”",
        imageName: "monki_think_normal"
    )
    
    StoryPageView(page: previewPage)
        .padding(26)
        .background(ColorPalette.yellow500)
}
