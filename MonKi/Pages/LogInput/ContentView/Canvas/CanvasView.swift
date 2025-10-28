//
//  CanvasView.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

import SwiftUI

struct CanvasView: View {
    
    @StateObject var viewModel: CanvasViewModel
    
    init(viewModel: CanvasViewModel = CanvasViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Image(ImageAsset.canvasBackground.imageName)
                .resizable()
                .ignoresSafeArea()
            
            Image(ImageAsset.canvasViewCloth.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 1.4,
                       height: UIScreen.main.bounds.height * 0.7,
                       alignment: .topLeading)
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
                        .offset(x: 70, y: 0)
                    
                    DrawingCanvasView(viewModel: viewModel)
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                
                Spacer()
                
                CanvasToolView(viewModel: viewModel)
                
                Spacer()
                
                ColorPickerView(viewModel: viewModel)
                
                Spacer()
            }
        }
    }
}

#Preview {
    CanvasView()
}
