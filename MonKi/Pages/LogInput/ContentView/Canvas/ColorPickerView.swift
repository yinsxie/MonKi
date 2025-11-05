//
//  ColorPickerView.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

struct ColorPickerView: View {
    
    @ObservedObject var viewModel: CanvasViewModel
    
    var body: some View {
        HStack(spacing: 11) {
            ForEach(ColoredPencilAsset.allCases, id: \.self) { coloredPencil in
                Image(coloredPencil.imageName)
                    .resizable()
                    .frame(width: 28.68, height: 92.98)
                    .offset(y: viewModel.selectedPencil == coloredPencil ? -10 : 0)
                    .animation(.spring(), value: viewModel.selectedPencil)
                    .onTapGesture {
                        SoundManager.shared.play(.pickCrayon)
                        viewModel.toggleColoredPencil(to: coloredPencil)
                    }
            }
        }
    }
}
