//
//  ParentalGateProtocol.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 04/11/25.
//

import Foundation

// MARK: - Protokol
protocol ParentalGateRepositoryProtocol {
    func savePinAndHint(pin: String, hint: String)
    
    func checkPIN(_ pin: String) -> Bool
    
    func getHint() -> String?
    
    func isPinCreated() -> Bool
}

// MARK: - Implementasi
final class ParentalGateRepository: ParentalGateRepositoryProtocol {
    private let userDefaults = UserDefaultsManager.shared
    
    func savePinAndHint(pin: String, hint: String) {
        userDefaults.setParentalGateAnswer(pin)
        userDefaults.setParentalGateQuestion(hint)
        
        print("ParentPinRepository: PIN dan Hint disimpan ke UserDefaults via Manager.")
    }
    
    func checkPIN(_ pin: String) -> Bool {
        let savedPIN: String? = userDefaults.getParentalGateAnswer()
        return pin == savedPIN
    }
    
    func getHint() -> String? {
        return userDefaults.getParentalGateQuestion()
    }
    
    func isPinCreated() -> Bool {
        let savedPIN: String? = userDefaults.getParentalGateAnswer()
        return savedPIN != nil
    }
}
