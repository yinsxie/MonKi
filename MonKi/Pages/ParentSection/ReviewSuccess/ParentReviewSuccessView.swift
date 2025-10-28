//
//  ParentReviewSuccessView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 28/10/25.
//

import SwiftUI

struct ParentReviewSuccessView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    enum SendState {
        case sending
        case sent
    }
    
    @State private var sendState: SendState = .sending
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ColorPalette.blue50.edgesIgnoringSafeArea(.all)
            
            ZStack {
                Image("ReviewSuccessWaterBackground")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.blue)
                
                if sendState == .sent {
                    Text("+1")
                        .font(.title3Emphasized)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(ColorPalette.neutral50)
                        .foregroundColor(.primary)
                        .cornerRadius(24)
                        .shadow(radius: 10)
                        .rotationEffect(Angle(degrees: 9))
                        .offset(x: 40, y: -150)
                        .transition(.scale.animation(.spring(response: 0.4, dampingFraction: 0.6)))
                }
            }
            
            VStack {
                VStack(spacing: 16) {
                    StatusTagView(state: sendState)
                        .padding(.top)
                    
                    Text("Pilihan anak sesuai dengan nilai keluarga!")
                        .font(.title1Emphasized)
                        .foregroundStyle(ColorPalette.neutral950)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                    
                    Text("Setetes air bisa bantu tanaman anak tumbuh dan anak semakin bijak mengelola kemauan")
                        .font(.bodyRegular)
                        .foregroundStyle(ColorPalette.neutral700)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 25)
                }
                
                Spacer()
                
                if sendState == .sent {
                    CustomButton(
                        text: "Kembali ke Beranda",
                        colorSet: .normal,
                        font: .calloutEmphasized,
                        action: {
                            navigationManager.popLast()
                        },
                        cornerRadius: 24,
                        width: 180,
                        type: .normal
                    )
                    .transition(.opacity.animation(.easeIn))
                }
            }
            .padding(.top, 100)
            .padding(.bottom, 92)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            simulateSend()
        }
    }
    
    func simulateSend() {
        Task {
            sendState = .sending
            try? await Task.sleep(for: .seconds(5))
            withAnimation(.spring()) {
                sendState = .sent
            }
        }
    }
}

struct StatusTagView: View {
    let state: ParentReviewSuccessView.SendState
    
    var body: some View {
        Group {
            if state == .sending {
                Text("Sedang mengirim air ke anak...")
            } else {
                HStack(spacing: 4) {
                    Text("Berhasil terkirim")
                    Image(systemName: "checkmark.seal.fill")
                }
            }
        }
        .font(.footnoteEmphasized)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(ColorPalette.blue100)
        .foregroundColor(ColorPalette.blue700)
        .cornerRadius(8)
        .animation(.easeInOut, value: state)
    }
}

#Preview {
    ParentReviewSuccessView()
}
