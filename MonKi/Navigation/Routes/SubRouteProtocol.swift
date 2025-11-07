//
//  SubRouteProtocol.swift
//  MonKi
//
//  Created by William on 06/11/25.
//
import SwiftUI

protocol SubRouteProtocol: Hashable {
    associatedtype Body: View
    @ViewBuilder
    func delegateView() -> Body
}
