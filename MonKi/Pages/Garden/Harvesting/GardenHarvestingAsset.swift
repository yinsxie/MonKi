//
//  GardenHarvestingAsset.swift
//  MonKi
//
//  Created by William on 29/10/25.
//

enum GardenHarvestingAsset {
    case frame1
    case frame2

    var imageName: String {
        switch self {
        case .frame1: return "WateringHarvestingF1"
        case .frame2: return "HarvestingF2"
        }
    }
}

enum GardenHarvestingHelperAsset: CaseIterable {
    case hand
    
    var imageName: String {
        switch self {
        case .hand:
            return "HarvestingF1HarvestHand"
        }
    }
}
