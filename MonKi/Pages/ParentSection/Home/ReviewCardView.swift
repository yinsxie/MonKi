//
//  ReviewCardView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 28/10/25.
//

import Foundation
import SwiftUI

struct ReviewCardView: View {
    let log: MsLog
    @EnvironmentObject var navigationManager: NavigationManager
    
    var onReject: () -> Void = {}
    
    private func parse(tagsString: String?) -> [String] {
        guard let tagsString = tagsString, !tagsString.isEmpty else {
            return []
        }
        return tagsString.split(separator: ";")
            .map { String($0).trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
    
    private var beneficialTags: [String] {
        parse(tagsString: log.beneficialTags)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
            
            RoundedRectangle(cornerRadius: 24)
                .inset(by: 1)
                .stroke(ColorPalette.yellow500, lineWidth: 2)
            
            VStack(spacing: 0) {
                ZStack(alignment: .bottomTrailing) {
                    HStack {
                        
                        if let imagePath = log.imagePath, let uiImage = ImageStorage.loadImage(from: imagePath) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .offset(y: 3)
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Anak bilang,\nini berguna untuk...")
                                .font(.subheadlineEmphasized)
                                .foregroundColor(ColorPalette.orange900)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            FlowLayout(alignment: .leading, spacing: 4) {
                                ForEach(beneficialTags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.caption2Semibold)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(ColorPalette.yellow200)
                                        .foregroundColor(ColorPalette.yellow800)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    if log.isHappy == true {
                        Image("EmoteLove")
                            .resizable()
                            .frame(width: 72, height: 72)
                            .offset(x: 12, y: 10)
                    } else {
                        Image("EmoteBiasa")
                            .resizable()
                            .frame(width: 72, height: 72)
                            .offset(x: 12, y: 10)
                    }
                }
                
                HStack(alignment: .center, spacing: 8) {
                    CustomButton(
                        text: "Tolak",
                        colorSet: .destructive,
                        font: .headlineEmphasized,
                        action: onReject,
                        cornerRadius: 24,
                        type: .normal
                    )
                    
                    CustomButton(
                        text: "Terima",
                        colorSet: .primary,
                        font: .headlineEmphasized,
                        action: {
                            navigationManager.goTo(
                                .parentHome(.reviewSuccess(log: log)
                                )
                            )
                        },
                        cornerRadius: 24,
                        type: .normal
                    )
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 16)
                .background(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: 24,
                        bottomTrailingRadius: 24
                    )
                    .fill(ColorPalette.yellow500)
                )
                
            }
        }
    }
}

struct ReviewCardView_Previews: PreviewProvider {
    static var previews: some View {
        ParentHomeView()
    }
}
