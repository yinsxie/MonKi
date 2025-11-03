//
//  ParentReviewSuccessView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 28/10/25.
//

import SwiftUI
import Combine

struct ParentReviewSuccessView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var viewModel: ParentHomeViewModel
    
    let logToApprove: MsLog
    
    enum SendState {
        case sending
        case sent
    }
    
    @State private var sendState: SendState = .sending
    @State private var approvalTask: Task<Void, Error>?
    
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
                
                if sendState == .sending {
                    CustomButton(
                        text: "Batalin Aksi Terima",
                        colorSet: .destructive,
                        font: .calloutEmphasized,
                        action: {
                            cancelApproval()
                        },
                        cornerRadius: 24,
                        width: 180,
                        type: .normal
                    )
                    .transition(.opacity.animation(.spring(response: 0.4, dampingFraction: 0.8)))
                } else if sendState == .sent {
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
                    .transition(.opacity.animation(.spring(response: 0.4, dampingFraction: 0.8)))
                }
            }
            .padding(.top, 100)
            .padding(.bottom, 92)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            startApprovalProcess()
        }
        .onDisappear {
            approvalTask?.cancel()
        }
    }
    
    func startApprovalProcess() {
        approvalTask = Task {
            sendState = .sending
            do {
                try await Task.sleep(for: .seconds(3))
                
                viewModel.approveLog(log: logToApprove)
                
                withAnimation(.spring()) {
                    sendState = .sent
                }
                
            } catch is CancellationError {
                print("Approval cancelled by user.")
            } catch {
                print("An error occurred: \(error.localizedDescription)")
                navigationManager.popLast()
            }
        }
    }
    
    func cancelApproval() {
        approvalTask?.cancel()
        navigationManager.popLast()
    }
}

struct StatusTagView: View {
    let state: ParentReviewSuccessView.SendState
    
    @State private var dots: Int = 1
    @State private var timerCancellable: AnyCancellable?
    
    var body: some View {
        Group {
            if state == .sending {
                Text("Sedang mengirim air ke anak" + String(repeating: ".", count: dots))
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
        
        .onAppear {
            if state == .sending {
                startDotAnimation()
            }
        }
        
        .onDisappear {
            stopDotAnimation()
        }
        
        .onChange(of: state) {
            if state == .sending {
                startDotAnimation()
            } else {
                stopDotAnimation()
            }
        }
    }
    
    func startDotAnimation() {
        stopDotAnimation()
        
        timerCancellable = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.dots = (self.dots % 3) + 1
                }
            }
    }
    
    func stopDotAnimation() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
