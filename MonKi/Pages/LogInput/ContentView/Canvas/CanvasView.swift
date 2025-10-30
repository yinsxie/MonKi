//
//  CanvasView.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

import SwiftUI

struct CanvasView: View {
    @EnvironmentObject var viewModel: CanvasViewModel

    var body: some View {
        ZStack {
            Image(ImageAsset.canvasBackground.imageName)
                .resizable()
                .ignoresSafeArea()
            
            Image(ImageAsset.canvasViewCloth.imageName)
                .resizable()
                .scaledToFit()
            //                .frame(height: UIScreen.main.bounds.height * 0.75,
            //                                       alignment: .topLeading)
                .frame(maxWidth: .infinity)
                .clipped()
                .offset(x: -150, y: -200)
                .id("clothBackground")
                .ignoresSafeArea()
            
            Image(ImageAsset.canvasViewButton.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 357.26, height: 278.08)
                .offset(x: 50, y: -320)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                ZStack {
                    Image(ImageAsset.canvasViewPaperNote.imageName)
                        .resizable()
                        .frame(width: 384.68, height: 363.87)
                        .scaledToFit()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    //                        .offset(x: 60, y: 0)
                    
                    DrawingCanvasView(viewModel: _viewModel)
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                Spacer()
                
                CanvasToolView(viewModel: viewModel)
                
                Spacer()
                
                ColorPickerView(viewModel: viewModel)
                
                Spacer()
            }
            .ignoresSafeArea()
            .padding(.vertical, 100)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CanvasView()
        .environmentObject(CanvasViewModel()) // Provide VM for preview
}
