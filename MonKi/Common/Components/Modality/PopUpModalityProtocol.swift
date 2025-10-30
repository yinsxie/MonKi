//
//  PopUpModalityProtocol.swift
//  MonKi
//
//  Created by William on 30/10/25.
//

enum ImageModalityIcon {
    case monkiThinking
    
    var imageName: String {
        //TODO: add this asset
        switch self {
        case .monkiThinking:
            return "MonkiThinking"
        }
    }
}

protocol PopUpModalityProtocol {
    var imageIcon: ImageModalityIcon { get }
    var title: String { get }
    var subtitle: String? { get }
    var primaryButtonTitle: String? { get }
    var secondaryButtonTitle: String? { get }
    var onPrimaryButtonTap: (() -> Void)? { get }
    var onSecondaryButtonTap: (() -> Void)? { get }
}
