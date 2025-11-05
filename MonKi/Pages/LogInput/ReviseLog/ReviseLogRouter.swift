//
//  ReviseLogRouter.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 01/11/25.
//

import SwiftUI

struct ReLogRouter: View {
    
    @ObservedObject var viewModel: ReLogViewModel
    
    var body: some View {
        Group {
            if let page = ReLogPageEnum(rawValue: viewModel.currentIndex) {
                switch page {
                case .howHappy:
                    // Wire up the new view to the new ViewModel
                    ReLogHowHappyView(
                       viewModel: viewModel
                    )
                    
                case .howBeneficial:
                    // Wire up the new view to the new ViewModel
                    ReLogHowBeneficialView(viewModel: viewModel)
                }
            } else {
                Text("Error: Invalid page index (\(viewModel.currentIndex)).")
            }
        }
    }
}
