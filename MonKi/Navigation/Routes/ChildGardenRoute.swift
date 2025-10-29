//
//  ChildGardenRoute.swift
//  MonKi
//
//  Created by William on 28/10/25.
//

import SwiftUI

enum ChildGardenRoute: Hashable {
   case garden
}

extension ChildGardenRoute {
    @ViewBuilder
    func delegateView() -> some View {
        switch self {
        case .garden:
            Text("Garden")
        }
    }
}
