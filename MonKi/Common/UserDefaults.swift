//
//  UserDefaults.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

import Foundation

/// List of Identifier for determined userDefault keys
///
/// > Important: Conform to other teammates when adding new keys to avoid duplication. Be sure to double-check existing keys first.
enum UserDefaultsIdentifier {
    case parentalGateQuestion
    case parentalGateAnswer
    case currentFilledField
    case maxFieldCount
    case isNewUser
    
    var value: String {
        switch self {
        case .parentalGateQuestion:
            return "parental_gate_question"
        case .parentalGateAnswer:
            return "parental_gate_answer"
        case .currentFilledField:
            return "current_filled_field"
        case .maxFieldCount:
            return "max_field_count"
        case .isNewUser:
            return "is_new_user"
        }
    }
}

enum UserDefaultsError: Error {
    case maxFieldLessThanCurrentFilledField
}

/// Singleton for managing UserDefaults operations
///
/// Usage:
///
/// - Setter: Will set the value for the specified key
/// - Getter: Will retrieve the value for the specified key with an optional value
/// > Important: Getters return optional values, so make sure to unwrap them safely
///
/// >Warning:
/// For setting `maxFieldCount`, it will throw an error if the new value is less than currentFilledField

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    func setParentalGateQuestion(_ question: String) {
        set(value: question, for: .parentalGateQuestion)
    }
    
    func getParentalGateQuestion() -> String? {
        return get(for: .parentalGateQuestion)
    }
    
    func setParentalGateAnswer(_ answer: String) {
        set(value: answer, for: .parentalGateAnswer)
    }
    
    func getParentalGateAnswer() -> String? {
        return get(for: .parentalGateAnswer)
    }
    
    func setCurrentFilledField(_ count: Int) {
        set(value: count, for: .currentFilledField)
    }
    
    func getCurrentFilledField() -> Int? {
        return get(for: .currentFilledField)
    }
    
    func setMaxFieldCount(_ count: Int) throws {
        if let currentField = getCurrentFilledField() {
            guard count >= currentField else {
                throw UserDefaultsError.maxFieldLessThanCurrentFilledField
            }
        }
        
        set(value: count, for: .maxFieldCount)
    }
    
    func setIsNewUser(_ isNew: Bool) {
        set(value: isNew, for: .isNewUser)
    }
    
    func getIsNewUser() -> Bool? {
        return get(for: .isNewUser)
    }
}

private extension UserDefaultsManager {
    func set<T>(value: T, for identifier: UserDefaultsIdentifier) {
        UserDefaults.standard.set(value, forKey: identifier.value)
    }
    
    func get<T>(for identifier: UserDefaultsIdentifier) -> T? {
        return UserDefaults.standard.object(forKey: identifier.value) as? T
    }
}
