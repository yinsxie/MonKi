//
//  ReviseLogNavigationContainer.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 01/11/25.
//

import SwiftUI

struct ReLogNavigationContainer: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel: ReLogViewModel
    
    /// Initialize this view with the log you want to edit
    init(logToEdit: MsLog) {
        _viewModel = StateObject(
            wrappedValue: ReLogViewModel(
                logToEdit: logToEdit,
                logRepository: LogRepository()
            )
        )
    }
    
    var body: some View {
        // We REUSE the existing navigation view
        ChildLogNavigationView(
            currentIndex: $viewModel.currentIndex,
            pageCount: viewModel.pageCount,
            isProgressBarHidden: false, // We always want the progress bar
            onClose: {
                // This is the 'X' button
                print("ReLog closed via 'X' button.")
                navigationManager.popLast()
            },
            customNextAction: { defaultCloseAction in
                // This is the "Next" / "Done" button
                viewModel.handleNextAction(onClose: {
                    print("ReLog finished, closing.")
                    // defaultCloseAction() is the built-in function to close the view
//                    defaultCloseAction()
                    navigationManager.popToRoot()
                    navigationManager.goTo(.childGarden(.home))
                    // You might also need to pop from your custom navigationManager
                    // if defaultCloseAction() doesn't do it.
                    // navigationManager.popLast()
                })
            },
            customBackAction: {
                // This is the "Back" button
                viewModel.handleBackAction()
            },
            isNextDisabled: viewModel.shouldDisableNext(),
            content: {
                // Plug in our *new* router
                ReLogRouter(viewModel: viewModel)
            }
        )
    }
}
