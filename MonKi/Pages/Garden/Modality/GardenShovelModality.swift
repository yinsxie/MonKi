//
//  GardenShovelModality.swift
//  MonKi
//
//  Created by William on 02/11/25.
//

import UIKit

enum GardenShovelModality: PopUpModalityProtocol {
    
    case exit(image: UIImage, onPrimaryButtonTap: () -> Void)
    case commit(image: UIImage, onPrimaryButtonTap: () -> Void)
    
    var imageIcon: ImageModalityIcon? {
        return nil
    }
    
    var imageDirect: UIImage? {
        switch self {
        case .exit(let image, _):
            return image
        case .commit(let image, _):
            return image
        }
    }
    
    var title: String {
        return "Apakah kamu ingin membuang barang ini?"
    }
    
    var subtitle: String? {
        return nil
    }
    
    var primaryButtonTitle: String? {
        return "Yakin"
    }
    
    var secondaryButtonTitle: String? {
        return nil
    }
    
    var onPrimaryButtonTap: (() -> Void)? {
        switch self {
        case .exit(_, let action):
            return action
        case .commit(_, let action):
            return action
        }
    }
    
    var onSecondaryButtonTap: (() -> Void)? {
        return nil
    }
    
    
}
