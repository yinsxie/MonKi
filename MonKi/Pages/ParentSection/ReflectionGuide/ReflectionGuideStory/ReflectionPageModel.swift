//
//  ReflectionPageModel.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 29/10/25.
//

import Foundation

struct ReflectionPage: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let text: String
    let imageName: String
}
