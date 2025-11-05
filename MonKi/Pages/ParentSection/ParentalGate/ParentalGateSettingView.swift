//
//  ParentalGateSettingView.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 04/11/25.
//

import SwiftUI

struct ParentalGateSettingView: View {
    
    // MARK: - State Properties
    @ObservedObject var viewModel: ParentalGateSettingViewModel
    @FocusState private var isPinFieldFocused: Bool
    
    // MARK: - Body
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Image("PapaMonki")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)
                    .offset(x: -24, y: -20)
                
                Spacer()
                
                Image("MamaMonki")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)
                    .offset(x: 24, y: -4)
            }
            
            VStack(spacing: 24) {
                
                Text("Bikin kode rahasia Parents")
                    .font(Font.title2Emphasized)
                    .foregroundStyle(ColorPalette.neutral950)
                    .multilineTextAlignment(.center)
                // Subjudul
                Text("Kode 4 angka ini perlu biar halaman Parents cuma bisa dibuka Mama/Papa aja")
                    .font(Font.bodyMedium)
                    .foregroundStyle(ColorPalette.neutral400)
                    .multilineTextAlignment(.center)
                
                // Input PIN
                pinInputView
                    .padding(.bottom, 16)
                
                // Input Hint
                hintInputView
                
                Spacer()
                
                // Tombol Navigasi Bawah
                bottomButtonsView
                    .padding(.bottom)
            }
            .onAppear {
                isPinFieldFocused = true
            }
        }.padding(.horizontal, 24)
    }
    
    // MARK: - Helper Views
    private var pinInputView: some View {
        ZStack {
            TextField("", text: $viewModel.pin)
                .keyboardType(.numberPad)
                .focused($isPinFieldFocused)
                .accentColor(.clear)
                .foregroundColor(.clear)
                .opacity(0.01)
                .onChange(of: viewModel.pin) { _, newValue in
                    if newValue.count == 4 {
                        viewModel.pin = String(newValue.prefix(4))
                        isPinFieldFocused = false
                    }
                }
            
            HStack(spacing: 16) {
                ForEach(0..<4, id: \.self) { index in
                    pinBox(at: index)
                }
            }
            .onTapGesture {
                isPinFieldFocused = true
            }
        }
    }
    
    @ViewBuilder
    private func pinBox(at index: Int) -> some View {
        let isFilled = index < viewModel.pin.count
        
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(isFilled ? ColorPalette.blue50 : Color(.systemBackground))
                .frame(height: 72)
                .shadow(color: .black.opacity(0.2), radius: 4)
            
            if index < viewModel.pin.count {
                let charIndex = viewModel.pin.index(viewModel.pin.startIndex, offsetBy: index)
                let char = String(viewModel.pin[charIndex])
                Text(char)
                    .font(Font.title1Semibold)
                    .foregroundStyle(ColorPalette.blue500)
            }
        }
    }
    
    private var hintInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tambahkan Hint")
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField("contoh: tahun lahir saya", text: $viewModel.hint)
                .submitLabel(.done)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.2), radius: 4)
        }
    }
    
    private var bottomButtonsView: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            HStack(spacing: 12) {
                CustomButton(
                    colorSet: .cancel,
                    image: "arrow.left",
                    action: {
                        withAnimation {
                            viewModel.handleBack()
                        }
                    },
                    cornerRadius: 24,
                    width: totalWidth * 0.33, // 1/3
                    type: .bordered,
                    isDisabled: false
                )
                CustomButton(
                    text: "lanjutkan",
                    colorSet: .primary,
                    imageRight: "arrow.right",
                    action: {
                        withAnimation {
                            viewModel.handleContinue()
                        }
                    },
                    cornerRadius: 24,
                    width: totalWidth * 0.67, // 2/3
                    type: .normal,
                    isDisabled: viewModel.isContinueDisabled
                )
                .animation(.easeInOut(duration: 0.2), value: viewModel.isContinueDisabled)
            }
            .frame(width: totalWidth)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
        .frame(height: 60)
        .padding(.bottom)
    }
}
