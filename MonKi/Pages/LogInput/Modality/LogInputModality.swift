//
//  LogInputModality.swift
//  MonKi
//
//  Created by William on 01/11/25.
//

import UIKit

enum LogInputModality: PopUpModalityProtocol {
    
    case gardenFull(onPrimaryTap: () -> Void = {})
    
    var imageIcon: ImageModalityIcon? {
        switch self {
        case .gardenFull:
            return .monkiThinking
        }
    }
    
    var imageDirect: UIImage? {
        return nil
    }
    
    var title: String {
        switch self {
        case .gardenFull:
            return "Kebunmu sudah penuh!"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .gardenFull:
            return nil
        }
    }
    
    var primaryButtonTitle: String? {
        switch self {
        case .gardenFull:
            return "Ingin Buang"
        }
    }
    
    var secondaryButtonTitle: String? {
        switch self {
        case .gardenFull:
            return nil
        }
    }
    
    var onPrimaryButtonTap: (() -> Void)? {
        switch self {
        case .gardenFull(let onPrimaryTap):
            return onPrimaryTap
        }
    }
    
    var onSecondaryButtonTap: (() -> Void)? {
        switch self {
        case .gardenFull:
            return nil
        }
    }
    
    
}
