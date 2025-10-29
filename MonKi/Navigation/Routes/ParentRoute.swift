//
//  ParentRoute.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

enum ParentRoute: Hashable {
    case home
    case reviewDetail(log: MsLog)
    case reviewSuccess
    case reflectionGuide(log: MsLog)
}

extension ParentRoute {
    
    @ViewBuilder
    func delegateView() -> some View {
        switch self {
        case .home:
            ParentHomeView()
                .navigationBarBackButtonHidden(true)
        case .reviewDetail(let log):
            ParentReviewDetailView(log: log)
                .navigationBarBackButtonHidden(true)
        case .reviewSuccess:
            ParentReviewSuccessView()
                .navigationBarBackButtonHidden(true)
        case .reflectionGuide(let log):
            ReflectionGuideView(log: log)
                .navigationBarBackButtonHidden(true)
        }
    }
}
