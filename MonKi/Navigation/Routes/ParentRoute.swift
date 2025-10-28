//
//  ParentRoute.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

enum ParentRoute: Hashable {
    case home
    case reviewDetail
}

extension ParentRoute {
    
    @ViewBuilder
    func delegateView() -> some View {
        switch self {
        case .home:
            Text("Parent Home")
        case .reviewDetail:
            Text("Review Detail")
        }
    }
}
