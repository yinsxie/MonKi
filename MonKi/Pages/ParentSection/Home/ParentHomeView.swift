//
//  ParentHomeView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 27/10/25.
//

import SwiftUI

struct ParentHomeView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel = ParentHomeViewModel()
    
    func didTapHomeButton() {
        print("Home Tapped")
        navigationManager.popToRoot()
    }
    func didTapPrevButton() { print("Previous Tapped") }
    func didTapNextButton() { print("Next Tapped") }
    
    var body: some View {
        GeometryReader { geometry in
            
            ZStack(alignment: .top) {
                
                ColorPalette.neutral50.ignoresSafeArea(.all)
                
                ScrollView {
                    ZStack(alignment: .top) {
                        
                        Circle()
                            .fill(ColorPalette.yellow100)
                            .offset(y: geometry.size.height / 3 )
                            .scaleEffect(3.0)
                        
                        VStack(spacing: 0) {
                            
                            HStack {
                                CustomButton(
                                    backgroundColor: ColorPalette.yellow600,
                                    foregroundColor: ColorPalette.yellow400,
                                    textColor: ColorPalette.yellow50,
                                    image: "kidsButton",
                                    imageHeight: 60,
                                    action: didTapHomeButton,
                                    cornerRadius: 24,
                                    width: 64,
                                    type: .normal
                                )
                                
                                Spacer()
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                            
                            VStack(spacing: 12) {
                                if viewModel.logsForParent.isEmpty {
                                    Text("Belum ada permintaan")
                                        .font(.title1Emphasized)
                                        .foregroundStyle(ColorPalette.neutral950)
                                    
                                    Text("Ajak anak tulis keinginannya di MonKi, lalu parents bisa periksa di sini")
                                        .font(.bodyRegular)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(ColorPalette.neutral700)
                                        .padding(.horizontal, 24)
                                } else {
                                    Text("Ada permintaan baru!")
                                        .font(.title1Emphasized)
                                        .foregroundStyle(ColorPalette.neutral950)
                                    
                                    Text("Waktunya periksa daftar keinginan anak, jangan lupa ajak diskusi biar anak makin paham")
                                        .font(.bodyRegular)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(ColorPalette.neutral700)
                                        .padding(.horizontal, 24)
                                }
                            }
                            .padding(.top, 20)
                            
                            HStack(alignment: .bottom) {
                                CustomButton(
                                    backgroundColor: ColorPalette.yellow600,
                                    foregroundColor: ColorPalette.yellow400,
                                    textColor: ColorPalette.neutral50,
                                    font: .system(size: 20, weight: .black, design: .rounded),
                                    image: "arrow.left",
                                    action: didTapPrevButton,
                                    cornerRadius: 24,
                                    width: 72,
                                    type: .normal
                                )
                                
                                Spacer()
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(ColorPalette.neutral300)
                                    .frame(width: 125, height: 125)
                                    .padding(.bottom, 15)
                                
                                Spacer()
                                
                                CustomButton(
                                    backgroundColor: ColorPalette.yellow600,
                                    foregroundColor: ColorPalette.yellow400,
                                    textColor: ColorPalette.neutral50,
                                    font: .system(size: 20, weight: .black, design: .rounded),
                                    image: "arrow.right",
                                    action: didTapNextButton,
                                    cornerRadius: 24,
                                    width: 72,
                                    type: .normal
                                )
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 70)
                            
                            // 7. Card Grid or Empty State
                            if viewModel.logsForParent.isEmpty {
                                VStack(spacing: 8) {
                                    Text("Masih kosong di sini~")
                                        .font(.title3Emphasized)
                                        .foregroundStyle(ColorPalette.neutral950)
                                    
                                    Text("Saat anak punya keinginan baru,\nParents bisa kasih pendapat di sini.")
                                        .font(.bodyRegular)
                                        .multilineTextAlignment(.center)
                                        .foregroundStyle(ColorPalette.neutral950)
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 30)
                                .padding(.bottom, 100)
                                
                            } else {
                                VStack(spacing: 28) {
                                    ForEach(viewModel.logsForParent) { log in
                                        ReviewCardView(
                                            log: log,
                                            onReject: {
                                                withAnimation {
                                                    viewModel.setBufferLog(log: log)
                                                    viewModel.toggleModalityOnRejection(to: true)
                                                }
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 60)
                                .padding(.bottom, 100)
                            }
                        }
                    }
                }
                .ignoresSafeArea(edges: .bottom)
                
                //Alerts
                if viewModel.showModalityOnRejection {
                    popUpView
                }
                
            }
        }
        .onAppear {
            viewModel.loadLogs()
        }
    }
    
    var popUpView: some View {
        PopUpView(
            type: ParentSectionModalType.onRejectButtonTapped(
                onPrimaryTap: {
                    if let log = viewModel.logBuffer {
                        viewModel.rejectLog(log: log)
                    }
                    viewModel.navigateToReflectionStory(context: navigationManager, forLog: viewModel.logBuffer)
                    withAnimation {
                        viewModel.toggleModalityOnRejection(to: false)
                    }
                },
                onSecondaryTap: {
                    withAnimation {
                        viewModel.toggleModalityOnRejection(to: false)
                    }
                    if let log = viewModel.logBuffer {
                        viewModel.rejectLog(log: log)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        viewModel.navigateToRejectView(context: navigationManager, forLog: viewModel.logBuffer)
                    }
                }
            )
        ) {
            withAnimation {
                viewModel.toggleModalityOnRejection(to: false)
                viewModel.setBufferLog(log: nil)
            }
        }
        .zIndex(1)
    }
}

// Xcode Preview
struct ParentHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ParentHomeView()
            .environmentObject(ParentHomeViewModel())
            .environmentObject(NavigationManager())
    }
}
