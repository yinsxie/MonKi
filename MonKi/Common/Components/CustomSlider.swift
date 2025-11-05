//
//  CustomSlider.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 04/11/25.
//

import SwiftUI

struct CustomSlider: View {
    // MARK: - Properti
    @Binding var value: Int
    let image: UIImage
    
    private let thumbSize: CGFloat = 100
    private let trackHeight: CGFloat = 24
    
    // State internal
    @State private var temporaryDragOffset: CGFloat? = nil
    
    // MARK: - Init
    init(value: Binding<Int>, image: UIImage) {
        self._value = value
        self.image = image
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let effectiveWidth = totalWidth - thumbSize
            
            let valueAsPercentage = Double(value) / 2.0
            let snappedOffset = valueAsPercentage * effectiveWidth
            let currentOffset = temporaryDragOffset ?? snappedOffset
            
            ZStack(alignment: .leading) {
                // MARK: - Track Background
                Capsule()
                    .fill(ColorPalette.yellow100)
                    .frame(height: trackHeight)
                    .padding(.horizontal, 50)
                
                // MARK: - Dots (3 circles) di dalam track
                HStack {
                    Circle().fill(ColorPalette.yellow500).frame(width: trackHeight * 0.5)
                    Spacer()
                    Circle().fill(ColorPalette.yellow500).frame(width: trackHeight * 0.5)
                    Spacer()
                    Circle().fill(ColorPalette.yellow500).frame(width: trackHeight * 0.5)
                }
                .padding(.horizontal, 8)
                .padding(.horizontal, 50)
                .frame(height: trackHeight)
                
                // MARK: - Thumb Image (selalu di atas)
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: thumbSize, height: thumbSize)
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                    .offset(x: currentOffset ?? snappedOffset)
                    .zIndex(1) // Pastikan thumb di atas segalanya
                    .animation(.spring(response: 0.3, dampingFraction: 0.8), value: currentOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let rawOffset = snappedOffset + gesture.translation.width
                                let clampedOffset = min(max(0, rawOffset), effectiveWidth)
                                self.temporaryDragOffset = clampedOffset
                            }
                            .onEnded { _ in
                                let finalOffset = temporaryDragOffset ?? snappedOffset
                                let percentage = effectiveWidth > 0 ? (finalOffset ?? snappedOffset) / effectiveWidth : 0
                                
                                if percentage < 0.25 {
                                    self.value = 0
                                } else if percentage > 0.75 {
                                    self.value = 2
                                } else {
                                    self.value = 1
                                }
                                self.temporaryDragOffset = nil
                            }
                    )
            }
            .frame(height: thumbSize)
        }
        .frame(height: thumbSize)
    }
}
