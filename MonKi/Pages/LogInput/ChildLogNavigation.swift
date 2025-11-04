//
//  ChildLogNavigation.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import SwiftUI

struct ChildLogNavigationView<Content: View>: View {
    @Binding var currentIndex: Int
    @State private var isMovingForward: Bool = true
    let pageCount: Int
    let onClose: () -> Void
    let customNextAction: ((@escaping () -> Void) -> Void)?
    let customBackAction: (() -> Void)?
    let isNextDisabled: Bool
    let isProgressBarHidden: Bool
    let content: () -> Content
    
    init(
        currentIndex: Binding<Int>,
        pageCount: Int,
        isProgressBarHidden: Bool = false,
        onClose: @escaping () -> Void,
        customNextAction: ((@escaping () -> Void) -> Void)? = nil,
        customBackAction: (() -> Void)? = nil,
        isNextDisabled: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._currentIndex = currentIndex
        self.pageCount = pageCount
        self.onClose = onClose
        self.customNextAction = customNextAction
        self.customBackAction = customBackAction
        self.isNextDisabled = isNextDisabled
        self.isProgressBarHidden = isProgressBarHidden
        self.content = content
    }
    
    var body: some View {
        ZStack {
            ZStack {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.asymmetric(
                        insertion: .move(edge: isMovingForward ? .trailing : .leading),
                        removal: .move(edge: isMovingForward ? .leading : .trailing)
                    ))
                    .id(currentIndex)
            }
            .clipped()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut(duration: 0.3), value: currentIndex)
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                
                // MARK: - Progress Bar
                ProgressBar(
                    count: Double(currentIndex + 1) / Double(pageCount),
                    color: ColorPalette.orange500,
                    action: onClose,
                    isHidden: isProgressBarHidden
                )
                .padding(.horizontal)
                .padding(.top)
                
                Spacer()
                
                // MARK: Navigation buttons
                GeometryReader { geometry in
                    let totalWidth = geometry.size.width
                    
                    HStack(spacing: 12) {
                        // TODO: remove validation when home page is implemented
                        if currentIndex > 0 {
                            CustomButton(
                                colorSet: .previous,
                                font: .system(size: 36, weight: .black, design: .rounded),
                                image: "arrow.left",
                                action: {
                                    withAnimation {
                                        isMovingForward = false
                                        customBackAction?() ?? { currentIndex -= 1 }()
                                    }
                                },
                                width: totalWidth * 0.33, // 1/3
                                type: .bordered,
                                isDisabled: false
                            )
                        }
                        
                        CustomButton(
                            colorSet: .primary,
                            font: .system(size: 36, weight: .black, design: .rounded),
                            image: "arrow.right",
                            action: {
                                withAnimation {
                                    isMovingForward = true
                                    customNextAction?(onClose)
                                }
                            },
                            width: currentIndex == 0 ? totalWidth : totalWidth * 0.67, // 2/3
                            type: .normal,
                            isDisabled: isNextDisabled
                        )
                        .animation(.easeInOut(duration: 0.2), value: isNextDisabled)
                    }
                    .frame(width: totalWidth)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                .frame(height: 60)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}
