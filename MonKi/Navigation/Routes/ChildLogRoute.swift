//
//  ChildLogRoute.swift
//  MonKi
//
//  Created by William on 28/10/25.
//
import SwiftUI

enum ChildLogRoute: Hashable {
    case logInput
    case getSeed(image: UIImage?)
}

extension ChildLogRoute {
    
    @ViewBuilder
    func delegateView() -> some View {
        switch self {
        case .logInput:
            ChildLogNavigationContainer()
        case .getSeed(let logImage):
            GetSeedView(logImage: logImage)
        }
    }
}
