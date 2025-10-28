//
//  ReviewCardView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 28/10/25.
//

import Foundation
import SwiftUI

struct ReviewCard: Identifiable {
    let id: UUID
    let imageName: String
    let needsReview: Bool
}

struct ReviewCardView: View {
    let card: ReviewCard

    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 8, y: 2)
            
            VStack(spacing: 10) {
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                ZStack(alignment: .topTrailing) {
                    CustomButton(
                        text: "Review",
                        colorSet: .primary,
                        font: .headlineEmphasized,
                        action: {},
                        cornerRadius: 24,
                        width: 89,
                        type: .normal
                    )
                    if card.needsReview {
                        Circle()
                            .fill(ColorPalette.orange500)
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.top, 12)
            }
            
            if card.needsReview {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle")
                    Text("Perlu Ngobrol")
                }
                .font(.caption2Medium)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(ColorPalette.orange500)
                .foregroundColor(ColorPalette.orange50)
                .cornerRadius(8)
                .padding(.top, 12)
                .padding(.leading, 13.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }
}

struct ReviewCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ReviewCardView(card: ReviewCard(id: UUID(), imageName: "icecream_placeholder", needsReview: true))
                .previewDisplayName("Needs Review Card")

            ReviewCardView(card: ReviewCard(id: UUID(), imageName: "icecream_placeholder", needsReview: false))
                .previewDisplayName("Standard Card")
        }
        .frame(width: 172, height: 241)
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
