//
//  HappyLevelEnum.swift
//  MonKi
//
//  Created by William on 04/11/25.
//

enum HappyLevelEnum {
    case level1
    case level2
    case level3
    
    var description: String {
        switch self {
        case .level1:
            return "Neutral"
        case .level2:
            return "Happy"
        case .level3:
            return "Very Happy"
        }
    }
    
    var imageName: String {
        //TODO: Change the asset once the design has dropped
        switch self {
        case .level1:
            return "MonkiVeryHappy"
        case .level2:
            return "MonkiVeryHappy"
        case .level3:
            return "MonkiVeryHappy"
        }
    }
    
    var level: Int {
        switch self {
        case .level1:
            return 0
        case .level2:
            return 1
        case .level3:
            return 2
        }
    }
    
    init(level: Int) {
        switch level {
        case 0:
            self = .level1
        case 1:
            self = .level2
        case 2:
            self = .level3
        default:
            self = .level1
        }
    }
}
