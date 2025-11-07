//
//  GardenImageAsset.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

enum GardenImageAsset {
    case gardenBackground
    case gardenEmptyField
    case emptyFieldBase
    case emptyFieldOverlay
    
    var imageName: String {
        switch self {
        case .gardenBackground:
            return "GardenBackground"
        case .gardenEmptyField:
            return "GardenEmptyField"
        case .emptyFieldBase:
            return "EmptyFieldBase"
        case .emptyFieldOverlay:
            return "EmptyFieldOverlay"
        }
    }
}
