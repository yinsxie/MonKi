//
//  PopUpModalityProtocol.swift
//  MonKi
//
//  Created by William on 30/10/25.
//

import UIKit

enum ImageModalityIcon {
    case monkiThinking
    case monkiGirlThinking
    
    var imageName: String {
        //TODO: add this asset
        switch self {
        case .monkiThinking:
            return "MonkiThinking"
        case .monkiGirlThinking:
            return "MonkiGirlThinking"
        }
    }
}

protocol PopUpModalityProtocol {
    var imageIcon: ImageModalityIcon? { get }
    var imageDirect: UIImage? { get}
    var title: String { get }
    var subtitle: String? { get }
    var primaryButtonTitle: String? { get }
    var secondaryButtonTitle: String? { get }
    var onPrimaryButtonTap: (() -> Void)? { get }
    var onSecondaryButtonTap: (() -> Void)? { get }
}
