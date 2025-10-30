//
//  UploadImageView.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import SwiftUI
import PhotosUI

struct UploadPage: View {
    @ObservedObject var viewModel: ChildLogViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Selected Photo")
                .font(Font.title2Emphasized)
                .multilineTextAlignment(.center)
                .padding(.bottom, 32)
            
            // MARK: - Preview Area
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.1))
                
                if let error = viewModel.imageLoadError {
                    VStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.orange)
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else if let image = viewModel.previewImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(16)
                        .blur(radius: viewModel.backgroundRemover.isProcessing ? 2 : 0)
                        .animation(.easeInOut, value: viewModel.backgroundRemover.isProcessing)
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text("No photo selected")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                if viewModel.backgroundRemover.isProcessing {
                    Color.black.opacity(0.4)
                        .cornerRadius(16)
                    ProgressView("Processing...")
                        .tint(.white)
                        .foregroundColor(.white)
                        .padding()
                }
            }
            .frame(height: 300, alignment: .top)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            // MARK: - Pick Button
            
            CanvasToolButton(toolType: .undo) {
                viewModel.showPhotoPicker = true
            }.padding(.top, 24)
                .padding(.bottom, 8)
                .disabled(viewModel.backgroundRemover.isProcessing)
                .opacity(viewModel.backgroundRemover.isProcessing ? 0.5 : 1)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .padding(.vertical, 140)
    }
}

#Preview {
    UploadPage(viewModel: ChildLogViewModel())
}
