//
//  ParentRoute.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

typealias ReviewAction = (MsLog) -> Void

enum ParentRoute: Hashable {
    case home
    case reviewSuccess
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
        case .reviewSuccess:
            ParentReviewSuccessView()
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
