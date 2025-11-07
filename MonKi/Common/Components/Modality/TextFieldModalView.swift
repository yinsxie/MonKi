//
//  TextFieldModalView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 05/11/25.
//

import SwiftUI

struct TextFieldModalView: View {
    
    let type: TextFieldModalProtocol
    @Binding var text: String
    var isSaveButtonDisabled: Bool
    
    var onCancel: () -> Void
    var onSave: () -> Void
    var onTextChange: () -> Void
    
    private var characterCount: Int {
        text.count
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture(perform: onCancel)
                .transition(.opacity)
            
            VStack(spacing: 20) {
                Text(type.title)
                    .font(.calloutEmphasized)
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPalette.neutral950)
                
                VStack(spacing: 12) {
                    TextField(type.placeholder, text: $text)
                        .font(.bodyMedium)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 0)
                        .onChange(of: text) {
                            onTextChange()
                        }
                    
                    Text("\(characterCount) / \(type.maxCharacters) karakter")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(ColorPalette.blue500)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                
                HStack(spacing: 8) {
                    CustomButton(
                        text: type.cancelButtonTitle,
                        colorSet: .cancel,
                        font: .headlineEmphasized,
                        action: onCancel,
                        cornerRadius: 24,
                        width: 140,
                        type: .normal
                    )
                    
                    CustomButton(
                        text: type.saveButtonTitle,
                        colorSet: isSaveButtonDisabled ? .disabled : .primary,
                        font: .headlineEmphasized,
                        action: onSave,
                        cornerRadius: 24,
                        width: .infinity,
                        type: .normal
                    )
                    .disabled(isSaveButtonDisabled)
                    .animation(.easeInOut(duration: 0.2), value: isSaveButtonDisabled)
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.1), radius: 10, y: 4)
            .padding(.horizontal, 35)
            .transition(.scale.combined(with: .opacity))
        }
        .zIndex(10)
        .animation(.easeInOut(duration: 0.2), value: text)
    }
}

#Preview {
    struct TextFieldModalPreviewContainer: View {
        
        @State private var previewText: String = ""
        @State private var isModalVisible: Bool = true
        
        struct PreviewModalConfig: TextFieldModalProtocol {
            var title: String = "Ini Judul Preview Modal"
            var placeholder: String = "contoh: Tes"
            var maxCharacters: Int = 15
            var cancelButtonTitle: String = "Batal"
            var saveButtonTitle: String = "Simpan"
        }
        
        var body: some View {
            ZStack {
                VStack {
                    Text("Ini adalah view di belakang modal.")
                    Button("Tampilkan Modal Lagi") {
                        isModalVisible = true
                    }
                    .disabled(isModalVisible)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                
                if isModalVisible {
                    TextFieldModalView(
                        type: PreviewModalConfig(),
                        text: $previewText,
                        isSaveButtonDisabled: previewText.isEmpty,
                        onCancel: {
                            isModalVisible = false
                            previewText = ""
                        },
                        onSave: {
                            isModalVisible = false
                        },
                        onTextChange: {
                            if previewText.count > 15 {
                                previewText = String(previewText.prefix(15))
                            }
                        }
                    )
                }
            }
            .animation(.easeInOut, value: isModalVisible)
        }
    }
    
    return TextFieldModalPreviewContainer()
}
