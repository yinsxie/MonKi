//
//  ChildLogInputRouter.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 29/10/25.
//

import SwiftUI

struct ChildLogRouter: View {
    
    @ObservedObject var viewModel: ChildLogViewModel
    private var currentPage: ChildLogPageEnum {
        return ChildLogPageEnum(rawValue: viewModel.currentIndex) ?? .selectMode
    }

    var body: some View {
        switch currentPage {
        case .selectMode:
            SelectModePage(
                selectedMode: $viewModel.selectedMode,
                isGalleryPermissionGranted: $viewModel.isGalleryPermissionGranted,
                viewModel: viewModel
            )
            
        case .mainInput:
            if viewModel.selectedMode == "Draw" {
                CanvasView()
            } else {
                UploadPage(viewModel: viewModel)
            }
            
        case .finalImage:
            FinalImagePage(processedImage: viewModel.backgroundRemover.resultImage)
        }
    }
}
