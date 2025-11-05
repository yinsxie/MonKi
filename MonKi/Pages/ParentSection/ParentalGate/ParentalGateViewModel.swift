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
    @Published var showLoginError: Bool = false
    @Published var isPinInvalid: Bool = false
    @Published var invalidAttempts: Int = 0
    
    // MARK: - Dependencies
    
    private var navigationManager: NavigationManager
    private var pinRepository: ParentalGateRepositoryProtocol
    private var onSuccess: () -> Void
    
    // MARK: - Computed Properties
    
    var isContinueDisabled: Bool {
        return pin.count != 4 || !pin.isNumeric || isPinInvalid
    }
    
    // MARK: - Initialization
    init(
        navigationManager: NavigationManager,
        pinRepository: ParentalGateRepositoryProtocol = ParentalGateRepository(),
        onSuccess: @escaping () -> Void
    ) {
        self.navigationManager = navigationManager
        self.pinRepository = pinRepository
        self.onSuccess = onSuccess
        self.hint = pinRepository.getHint() ?? "Hint tidak diatur."
    }
    
    // MARK: - Actions
    
    func handleContinue() {
        guard !isContinueDisabled else { return }
        
        // Cek apakah PIN cocok
        if pinRepository.checkPIN(pin) {
            print("ParentalGateViewModel: PIN Benar. Memanggil onSuccess.")
            self.isPinInvalid = false
            onSuccess()
        } else {
            print("ParentalGateViewModel: PIN Salah.")
            self.showLoginError = true
            self.isPinInvalid = true
            self.invalidAttempts += 1
//            self.pin = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                //                            self.pin = ""
                self.isPinInvalid = false
            }
        }
    }
    
    func handleBack() {
        navigationManager.popLast()
    }
}
