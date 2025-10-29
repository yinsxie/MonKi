//
//  ChildLogRoute.swift
//  MonKi
//
//  Created by William on 28/10/25.
//
import SwiftUI

enum ChildLogRoute: Hashable {
    case logInput
}

extension ChildLogRoute {
    
    @ViewBuilder
    func delegateView() -> some View {
        switch self {
        case .logInput:
            ChildLogNavigationView(
                pages: [
                    ChildLogContent(title: "Headline 1", subtitle: "Lorem ipsum dolor sit amet", imageName: "checkmark", color: .orange),
                    ChildLogContent(title: "Headline 2", subtitle: "Consectetur adipiscing elit", imageName: "xmark", color: .green),
                    ChildLogContent(title: "Headline 3", subtitle: "Donec sit amet justo", imageName: "checkmark", color: .blue)
                ],
                onClose: { print("Onboarding closed") }
            )
            .navigationBarBackButtonHidden(true)
        }
    }
}
