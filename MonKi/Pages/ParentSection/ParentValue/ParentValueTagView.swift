//
//  ParentValueTagView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 01/11/25.
//

import SwiftUI

struct AddValueModalConfig: TextFieldModalProtocol {
    var title: String = "Belum ketemu yang pas? Tulis satu kata yang mewakili nilai keluargamu"
    var placeholder: String = "contoh: Kreatif"
    var maxCharacters: Int
    var cancelButtonTitle: String = "Kembali"
    var saveButtonTitle: String = "Simpan"
    
    init(maxCharacters: Int) {
        self.maxCharacters = maxCharacters
    }
}

struct ParentValueTagView: View {
    
    @StateObject private var viewModel = ParentValueTagViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 30) {
                HStack(alignment: .top) {
                    Image("MamaMonki")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 112)
                        .padding(.top, 17)
                    Spacer()
                    Image("PapaMonki")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                }
                .padding(.top, 25)
                
                VStack(alignment: .center, spacing: 70) {
                    // MARK: - Title & Subtitle
                    VStack(spacing: 8) {
                        Text("Berguna untuk apa, ya?")
                            .font(.title2Emphasized)
                            .foregroundColor(ColorPalette.neutral950)
                        
                        Text("Pilih nilai keluarga yang akan jadi panduan anak memikirkan manfaat hal yang diinginkan")
                            .font(.bodyMedium)
                            .foregroundColor(ColorPalette.neutral400)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: - Value Grid
                    FlowLayout(alignment: .center, spacing: 12) {
                        ForEach(viewModel.allValues, id: \.self) { value in
                            valueButton(for: value)
                        }
                        addButton()
                    }
                    .padding(.horizontal, 35)
                }
                
                Spacer()
                
            }
            .padding(.top)
            
            // MARK: - Footer Buttons
            footerButtons()
                .padding(.horizontal, 24)
                .padding(.bottom, 64)
            
            if viewModel.isShowingAddValueSheet {
                let modalConfig = AddValueModalConfig(
                    maxCharacters: viewModel.maxCustomValueChars
                )
                TextFieldModalView(
                    type: modalConfig,
                    text: $viewModel.customValueText,
                    isSaveButtonDisabled: viewModel.isAddButtonDisabled,
                    onCancel: {
                        viewModel.customValueText = "" // Reset text saat batal
                        viewModel.isShowingAddValueSheet = false
                    },
                    onSave: {
                        viewModel.addCustomValue()
                    },
                    onTextChange: {
                        viewModel.limitCustomValueText()
                    }
                )
            }
        }
        .navigationBarHidden(true)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isShowingAddValueSheet)
        .ignoresSafeArea(edges: [.top, .bottom])
        .onAppear {
            viewModel.loadTags()
        }
    }
    
    @ViewBuilder
    private func valueButton(for value: String) -> some View {
        let isSelected = viewModel.isSelected(value)
        
        Button(
            action: {
                viewModel.toggleSelection(for: value)
            },
            label: {
                Text(value)
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(isSelected ? ColorPalette.blue100 : ColorPalette.neutral50)
                    .foregroundColor(isSelected ? ColorPalette.blue700 : ColorPalette.neutral950)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.5)
                            .stroke(isSelected ? ColorPalette.blue300 : ColorPalette.neutral200, lineWidth: 1)
                    )
            }
        )
    }
    
    @ViewBuilder
    private func addButton() -> some View {
        Button(
            action: {
                viewModel.isShowingAddValueSheet = true
            },
            label: {
                Image(systemName: "plus")
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .background(ColorPalette.neutral50)
                    .foregroundColor(ColorPalette.neutral950)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(ColorPalette.neutral50)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 0.5)
                            .stroke(ColorPalette.neutral200, lineWidth: 1)
                    )
            }
        )
        .disabled(viewModel.selectedValues.count >= viewModel.maxSelection)
    }
    
    @ViewBuilder
    private func footerButtons() -> some View {
        let isEnabled = viewModel.isContinueButtonEnabled
        
        HStack(spacing: 18) {
            CustomButton(
                colorSet: .cancel,
                font: .system(size: 20, weight: .black, design: .rounded),
                image: "arrow.left",
                action: {
                    navigationManager.popLast()
                },
                cornerRadius: 24,
                width: 120,
                type: .normal
            )
            
            CustomButton(
                text: "Lanjutkan",
                colorSet: isEnabled ? .primary : .disabled,
                font: .headlineEmphasized,
                imageRight: "arrow.right",
                action: {
                    navigationManager.popLast()
                },
                cornerRadius: 24,
                width: .infinity,
                type: .normal
            )
            .disabled(!isEnabled)
            .animation(.easeInOut(duration: 0.2), value: isEnabled)
        }
    }
}

#Preview {
    ParentValueTagView()
}
