//
//  ParentalGateViewModel.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 04/11/25.
//

import Foundation
import Combine

final class ParentalGateViewModel: ObservableObject {
    
    // MARK: - State Properties
    @Published var pin: String = ""
    @Published var hint: String = ""
    
    // MARK: - Dependencies
    private var pinRepository: ParentalGateRepositoryProtocol
    private var onFinished: () -> Void
    
    // MARK: - Computed Properties
    var isContinueDisabled: Bool {
        return (pin.count != 4 || !pin.isNumeric) || hint.isEmpty
    }
    
    // MARK: - Initialization
    init(
        pinRepository: ParentalGateRepositoryProtocol = ParentalGateRepository(),
        onFinished: @escaping () -> Void
    ) {
        self.pinRepository = pinRepository
        self.onFinished = onFinished
    }
    
    // MARK: - Actions
    
    func handleContinue() {
        guard !isContinueDisabled else { return }
        
        pinRepository.savePinAndHint(pin: pin, hint: hint)

        UserDefaultsManager.shared.setIsNewUser(false)
        
        onFinished()
    }
    
    func handleBack() {
        print("Tombol 'Back' diclick, tidak ada action.")
    }
}
