//
//  ChildLogInputRouter.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 29/10/25.
//

import SwiftUI

struct ChildLogRouter: View {
    
    @ObservedObject var viewModel: ChildLogViewModel
    @EnvironmentObject var canvasViewModel: CanvasViewModel
    
    var body: some View {
        Group {
            if let inputPage = viewModel.currentInputPage {
                switch inputPage {
                case .selectMode:
                    SelectModePage(
                        selectedMode: $viewModel.inputSelectedMode,
                        isGalleryPermissionGranted: $viewModel.isGalleryPermissionGranted,
                        viewModel: viewModel
                    )
                    
                case .mainInput:
                    if viewModel.inputSelectedMode == "Draw" {
                        CanvasView()
                    } else {
                        UploadPage(viewModel: viewModel)
                    }
                    
                case .finalImage:
                    FinalImagePage(processedImage: viewModel.finalProcessedImage)
                }
            } else if let tagPage = viewModel.currentTagPage {
                switch tagPage {
                case .howHappy:
                    HowHappyView(selectedMode: $viewModel.tagSelectedMode, viewModel: viewModel)
                case .happyIllust:
                    FinalImagePage(processedImage: nil)
                case .howBeneficial:
                    HowBeneficialView(viewModel: viewModel)
                }
            } else {
                Text("Error: Indeks navigasi tidak valid (\(viewModel.currentIndex)).")
            }
        }
        .environmentObject(canvasViewModel)
    }
}
