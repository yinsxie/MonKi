//
//  LogInputModality.swift
//  MonKi
//
//  Created by William on 01/11/25.
//

import UIKit

enum LogInputModality: PopUpModalityProtocol {
    
    case gardenFull(onPrimaryTap: () -> Void = {})
    case withParent(onPrimaryTap: () -> Void = {}, onSecondaryTap: () -> Void = {})
    
    var imageIcon: ImageModalityIcon? {
        switch self {
        case .gardenFull:
            return .monkiThinking
        case .withParent:
            return .monkiGirlThinking
        }
    }
    
    var imageDirect: UIImage? {
        return nil
    }
    
    var title: String {
        switch self {
        case .gardenFull:
            return "Kebunmu sudah penuh!"
        case .withParent:
            return "Orang tuamu lagi disampingmu?"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .gardenFull:
            return nil
        case .withParent:
            return nil
        }
    }
    
    var primaryButtonTitle: String? {
        switch self {
        case .gardenFull:
            return "Ingin Buang"
        case .withParent:
            return "Iya"
        }
    }
    
    var secondaryButtonTitle: String? {
        switch self {
        case .gardenFull:
            return nil
        case .withParent:
            return "Tidak"
        }
    }
    
    var onPrimaryButtonTap: (() -> Void)? {
        switch self {
        case .gardenFull(let onPrimaryTap):
            return onPrimaryTap
        case .withParent(let onPrimaryTap, _):
            return onPrimaryTap
        }
    }
    
    var onSecondaryButtonTap: (() -> Void)? {
        switch self {
        case .gardenFull:
            return nil
            
        case .withParent(_, let onSecondaryTap):
            return onSecondaryTap
        }
    }
}
