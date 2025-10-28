//
//  ParentReviewDetailView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 28/10/25.
//

import SwiftUI

struct ParentReviewDetailView: View {
    
    let log: MsLog
    @StateObject private var viewModel: ParentReviewDetailViewModel
    
    // Environment property to dismiss this view
    @Environment(\.dismiss) private var dismiss
    
    init(log: MsLog) {
        self.log = log
        // Initialize the StateObject with the passed-in logId
        _viewModel = StateObject(wrappedValue: ParentReviewDetailViewModel(log: log))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                
                ColorPalette.orange500
                    .ignoresSafeArea()
                
                Circle()
                    .fill(ColorPalette.yellow300)
                    .offset(y: geometry.size.height / 2.3 )
                    .scaleEffect(3.0)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .top)
                
                // 2. Main Content
                VStack(alignment: .leading, spacing: 30) {
                    
                    closeButton
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Hey, Parents!")
                            .font(.title1Semibold)
                            .foregroundStyle(ColorPalette.yellow100)
                            .opacity(0.5)
                        
                        Text("Si kecil bilang,")
                            .font(.largeTitleEmphasized)
                            .foregroundStyle(ColorPalette.pink50)
                    }
                    
                    Image(viewModel.log.imagePath ?? "icecream_placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 158, height: 158)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(16)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Dynamic Tags
                    VStack(alignment: .leading, spacing: 16) {
                        if viewModel.log.isHappy == true {
                            happyTag
                        }
                        
                        if viewModel.log.isBeneficial == true && !viewModel.beneficialTags.isEmpty {
                            beneficialTags
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // 3. White Bottom Card
                bottomCard
                    .padding(.horizontal, 24)
                    .padding(.bottom, 30)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // MARK: - Subviews
    
    private var closeButton: some View {
        CustomButton(
            colorSet: .cancel,
            font: .title3Regular,
            image: "xmark",
            action: {
                dismiss()
            },
            cornerRadius: 24,
            width: 64,
            type: .normal
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var happyTag: some View {
        HStack(spacing: 12) {
            Text("bikin dia merasa")
                .font(.title3Emphasized)
                .foregroundColor(ColorPalette.pink50)
            
            Text("bahagia")
                .font(.title3Emphasized)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white)
                .foregroundColor(ColorPalette.orange600)
                .clipShape(Capsule())
        }
    }
    
    private var beneficialTags: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("bermanfaat untuk")
                .font(.title3Emphasized)
                .foregroundColor(ColorPalette.pink50)
                .padding(.top, 10) // Align with capsule padding
            
            // Horizontal scroll for tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.beneficialTags, id: \.self) { tag in
                        Text(tag)
                            .font(.title3Emphasized)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.white)
                            .foregroundColor(ColorPalette.orange600)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
    
    private var bottomCard: some View {
        VStack(alignment: .center, spacing: -18) {
            HStack(spacing: 8) {
                Image("SoftStar")
                    .frame(width: 12, height: 12)
                Text("Pendapat Parents")
                    .font(.bodyEmphasized)
                Image("SoftStar")
                    .frame(width: 12, height: 12)

            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(ColorPalette.orange600)
            .foregroundStyle(ColorPalette.neutral50)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .inset(by: -2)
                    .stroke(Color.white, lineWidth: 4)
            )
            .zIndex(1)
            
            VStack(spacing: 28) {
                Text("Apakah pemahaman anak udah sejalan sama nilai keluarga?")
                    .font(.bodySemibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                
                HStack(spacing: 16) {
                    CustomButton(
                        text: "Kurang Tepat",
                        colorSet: .normal,
                        font: .calloutEmphasized,
                        action: {
                            viewModel.rejectLog()
                            dismiss()
                        },
                        cornerRadius: 24,
                        width: 135,
                        type: .normal
                    )
                    
                    CustomButton(
                        text: "Sudah Benar!",
                        colorSet: .primary,
                        font: .calloutEmphasized,
                        action: {
                            viewModel.approveLog()
                            dismiss()
                        },
                        cornerRadius: 24,
                        width: 135,
                        type: .normal
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 28)
            .frame(maxWidth: .infinity)
            .background(ColorPalette.orange50)
            .cornerRadius(24)
        }
    }
}

//// MARK: - Preview
//struct ParentReviewDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ParentReviewDetailView(logId: UUID())
//    }
//}
