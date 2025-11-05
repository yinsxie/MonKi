//
//  ParentalGateView.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 04/11/25.
//

import SwiftUI

struct ParentalGateView: View {
    
    // MARK: - State Properties
    @ObservedObject var viewModel: ParentalGateViewModel
    @FocusState private var isPinFieldFocused: Bool
    @State private var localShakeAttempts: Int = 0
    
    // MARK: - Body
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                closeButton
                
                Spacer()
                
                Image("MamaMonkiLock")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)
                    .offset(x: 24, y: -15)
            }.padding(.top)
            
            VStack(spacing: 24) {
                
                Text("Masuk ke Halaman Parents")
                    .font(Font.title2Emphasized)
                    .foregroundStyle(ColorPalette.neutral950)
                    .multilineTextAlignment(.center)
                // Subjudul
                Text("Empat angka rahasia dibutuhkan untuk lanjut")
                    .font(Font.bodyMedium)
                    .foregroundStyle(ColorPalette.neutral400)
                    .multilineTextAlignment(.center)
                
                // Input PIN
                pinInputView
                    .padding(.bottom, 16)
                    .modifier(Shake(animatableData: CGFloat(localShakeAttempts)))
                
                Text("Hint: \(viewModel.hint)")
                    .font(Font.bodyMedium)
                    .foregroundStyle(ColorPalette.neutral400)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                // Tombol Navigasi Bawah
                bottomButtonsView
                    .padding(.bottom)
            }
            .onAppear {
                isPinFieldFocused = true
            }
            .onChange(of: viewModel.invalidAttempts) { _, _ in
                withAnimation(.default) {
                    localShakeAttempts += 1
                }
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
                .fill(viewModel.isPinInvalid ? Color.red.opacity(0.2) : (isFilled ? ColorPalette.blue50 : Color(.systemBackground)))
                .frame(height: 72)
                .shadow(color: .black.opacity(0.2), radius: 4)
            
            if index < viewModel.pin.count {
                let charIndex = viewModel.pin.index(viewModel.pin.startIndex, offsetBy: index)
                let char = String(viewModel.pin[charIndex])
                Text(char)
                    .font(Font.title1Semibold)
                    .foregroundStyle(viewModel.isPinInvalid ? Color.red : ColorPalette.blue500)
            }
        }
    }
    
    private var closeButton: some View {
        CustomButton(
            colorSet: .destructive,
            font: .system(size: 20, weight: .black, design: .rounded),
            image: "xmark",
            action: {
                withAnimation {
                    viewModel.handleBack()
                }
            },
            cornerRadius: 24,
            width: 64,
            type: .normal
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var bottomButtonsView: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            HStack(spacing: 12) {
                
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
                    width: totalWidth * 0.5,
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

// MARK: - Shake Effect Modifier
struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat // Ini adalah pemicunya

    func effectValue(size: CGSize) -> ProjectionTransform {
        // Rumus sinus untuk membuat getaran kiri-kanan
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

// MARK: - Preview
#Preview {
    // PreviewWrapper diperlukan untuk menginisialisasi
    // NavigationManager dan ViewModel dengan benar.
    struct PreviewWrapper: View {
        // Buat @EnvironmentObject palsu untuk preview
        @StateObject var navManager = NavigationManager()
        
        // Buat VM palsu untuk preview
        @StateObject var viewModel = ParentalGateViewModel(
            navigationManager: NavigationManager(),
            onSuccess: {
                print("Preview: Login Berhasil!")
            }
        )
        
        var body: some View {
            // Inject ViewModel ke ParentalGateView
            ParentalGateView(viewModel: viewModel)
            // Sediakan NavigationManager untuk view (jika diperlukan)
                .environmentObject(navManager)
        }
    }
    
    // Tampilkan PreviewWrapper
    return PreviewWrapper()
}
