//
//  GardenWateringAsset.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

enum GardenWateringAsset: CaseIterable {
    case frame1
    case frame2

    var imageName: String {
        switch self {
        case .frame1: return "WateringF1"
        case .frame2: return "WateringF2"
        }
    }
}

enum GardenWateringHelperAsset: CaseIterable {
    case wateringCan
    
    var imageName: String {
        switch self {
        case .wateringCan:
            return "WateringF1WateringCan"
        }
    }
}
