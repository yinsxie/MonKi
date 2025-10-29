//
//  ReflectionPageModel.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 29/10/25.
//

import Foundation

struct ReflectionCard: Identifiable, Hashable {
    let id = UUID()
    let title: String
    
    let mainTextPrefix: String
    let mainTextHighlight: String
    let mainTextSuffix: String
    
    let highlightedText: String?
    let imageName: String
}

struct ReflectionPage: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let cards: [ReflectionCard]
}
