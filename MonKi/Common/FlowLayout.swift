//
//  FlowLayout.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 30/10/25.
//
import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat

    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return calculateLayout(proposal: proposal, sizes: sizes).totalSize
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let layout = calculateLayout(proposal: proposal, sizes: sizes)
        
        for (index, subview) in subviews.enumerated() {
            let offset = layout.offsets[index]
            subview.place(at: CGPoint(x: offset.x + bounds.minX, y: offset.y + bounds.minY), proposal: .unspecified)
        }
    }

    private func calculateLayout(proposal: ProposedViewSize, sizes: [CGSize]) -> (offsets: [CGPoint], totalSize: CGSize) {
        var offsets: [CGPoint] = []
        var currentPosition: CGPoint = .zero
        var lineHeight: CGFloat = 0
        var totalSize: CGSize = .zero
        
        let availableWidth = proposal.width ?? .infinity

        for size in sizes {
            if currentPosition.x + size.width > availableWidth {
                currentPosition.x = 0
                currentPosition.y += lineHeight + spacing
                lineHeight = 0
            }

            offsets.append(currentPosition)
            
            currentPosition.x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
            
            totalSize.width = max(totalSize.width, currentPosition.x - spacing)
            totalSize.height = max(totalSize.height, currentPosition.y + lineHeight)
        }
        
        return (offsets, totalSize)
    }
}
