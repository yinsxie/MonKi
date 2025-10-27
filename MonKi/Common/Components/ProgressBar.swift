//
//  ProgressBar.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import SwiftUI

struct ProgressBar: View {
    let count: Double
    let color: Color
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: action) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.gray)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 55)
                        .fill(ColorPalette.neutral200)
                        .frame(height: 20)
                    
                    RoundedRectangle(cornerRadius: 55)
                        .fill(color)
                        .frame(width: geometry.size.width * count, height: 20)
                        .animation(.easeInOut(duration: 0.3), value: count)
                }
            }
        }
        .frame(height: 20)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressBar(count: 0.3, color: .orange, action: {})
        ProgressBar(count: 0.75, color: .green, action: {})
    }
    .padding()
}
