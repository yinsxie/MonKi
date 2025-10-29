//
//  StoryProgressBar.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 29/10/25.
//

import SwiftUI

struct StoryProgressBar: View {
    let totalSegments: Int
    let currentSegment: Int
    let progress: Double
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSegments, id: \.self) { index in
                if index < currentSegment {
                    // Past segments (already viewed)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(ColorPalette.orange800)
                        .frame(height: 7)
                } else if index == currentSegment {
                    // Current, active segment (animating)
                    CurrentSegmentView(progress: progress)
                } else {
                    // Future segments (not yet viewed)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(ColorPalette.pink50)
                        .frame(height: 7)
                }
            }
        }
        .frame(maxHeight: 7)
    }
    
    /// A helper view for the animating segment
    private struct CurrentSegmentView: View {
        let progress: Double
        
        var body: some View {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Background (empty part)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(ColorPalette.pink50)

                    // Foreground (filled part)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(ColorPalette.orange800)
                        .frame(width: geo.size.width * CGFloat(progress))
                }
                .frame(height: 7)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                // Animate the progress change
                .animation(.linear(duration: 0.05), value: progress)
            }
        }
    }
}

#Preview {
    StoryProgressBar(totalSegments: 4, currentSegment: 1, progress: 0.75)
        .padding()
        .background(.black)
}
