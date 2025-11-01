//
//  TagSelectionView.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 29/10/25.
//

import SwiftUI

private struct DisplayTagItem: Identifiable, Hashable {
    var id: BeneficialTag { tag }
    let text: String
    let tag: BeneficialTag
}

// MARK: - 3. Main Page Logic
struct TagSelectionPageView: View {
    
    let tagTexts: [String]
    @State private var displayedTags = [DisplayTagItem]()
    @Binding var selectedTags: Set<BeneficialTag>
    private let maxSelection = 2
    
    init(tagTexts: [String], selectedTags: Binding<Set<BeneficialTag>>) {
        self.tagTexts = tagTexts
        self._selectedTags = selectedTags
    }
    
    var body: some View {
        ZStack {
            conditionallyCreateTagView(for: .star, offset: .init(width: -110, height: -100))
            conditionallyCreateTagView(for: .hexagon, offset: .init(width: 90, height: 80), rotation: .degrees(45))
            conditionallyCreateTagView(for: .square, offset: .init(width: -100, height: 155))
            conditionallyCreateTagView(for: .circle, offset: .init(width: 85, height: -75))
            conditionallyCreateTagView(for: .cloud, offset: .init(width: -40, height: 20))
            conditionallyCreateTagView(for: .triangle, offset: .init(width: 25, height: 210))
        }
        .frame(height: 400)
        .onAppear {
            setupDisplayedTags()
        }
        .onChange(of: tagTexts) { _, _ in
             setupDisplayedTags()
        }
    }
    
    private func setupDisplayedTags() {
        displayedTags = []
        let allShapes = BeneficialTag.allCases
        
        for (text, tag) in zip(tagTexts, allShapes) {
            displayedTags.append(DisplayTagItem(text: text, tag: tag))
        }
    }

    @ViewBuilder
    private func conditionallyCreateTagView(for tag: BeneficialTag, offset: CGSize, rotation: Angle = .degrees(0)) -> some View {
        if let item = displayedTags.first(where: { $0.tag == tag }) {
            
            let isSelected = selectedTags.contains(tag)
            let isSelectionLocked = (selectedTags.count >= maxSelection && !isSelected)
            
            TagShapeView(
                tag: item.tag,
                text: item.text,
                isSelected: isSelected,
                isSelectionLocked: isSelectionLocked
            )
            .rotationEffect(rotation)
            .offset(x: offset.width, y: offset.height)
            .onTapGesture {
                handleTap(on: item.tag)
            }
            
        } else {
            EmptyView()
        }
    }
    
    private func handleTap(on tag: BeneficialTag) {
        if selectedTags.contains(tag) {
            SoundManager.shared.play(.tagClick)
            selectedTags.remove(tag)
        } else if selectedTags.count < maxSelection {
            SoundManager.shared.play(.tagClick)
            selectedTags.insert(tag)
        } else{
            SoundManager.shared.play(.popUredo)
        }
    }
}
