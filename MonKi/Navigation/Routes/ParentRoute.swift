//
//  ParentRoute.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

enum ParentRoute: Hashable {
    case home
    case reviewSuccess(log: MsLog)
    case reflectionGuideStory(log: MsLog)
    case reviewReject(log: MsLog)
}

extension ParentRoute {
    
    @ViewBuilder

    func delegateView() -> some View {
        switch self {
        case .home:
            ParentHomeView()
                .navigationBarBackButtonHidden(true)
        case .reviewSuccess(let log):
            ParentReviewSuccessView(logToApprove: log)
                .navigationBarBackButtonHidden(true)
        case .reflectionGuideStory(let log):
            ReflectionGuideStoryView(log: log)
                .navigationBarBackButtonHidden(true)
        case .reviewReject(log: let log):
            ParentReviewRejectView(log: log)
                .navigationBarBackButtonHidden(true)
        }
    }
}
