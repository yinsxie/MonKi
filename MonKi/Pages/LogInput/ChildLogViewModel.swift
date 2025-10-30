//
//  ChildLogViewModel.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import SwiftUI
import PhotosUI
import CoreData

@MainActor
internal class ChildLogViewModel: ObservableObject {
    // MARK: - Navigation & State
    @Published var currentIndex: Int = 0
    @Published var selectedMode: String?
    @Published var isGalleryPermissionGranted: Bool = false
    @Published var showingPermissionAlert: Bool = false
    
    // MARK: - Image Handling
    @Published var selectedItem: PhotosPickerItem?
    @Published var previewImage: UIImage?
    @Published var imageLoadError: String?
    @Published var showPhotoPicker = false
    
    // MARK: - Image Processors & Final Image
    @Published var backgroundRemover = BackgroundRemoverViewModel()
    @Published var canvasViewModel = CanvasViewModel()
    @Published var finalProcessedImage: UIImage?
    
    // MARK: - Core Data Log
    private let context: NSManagedObjectContext
    
    // MARK: - Computed Properties
    var currentPage: ChildLogPageEnum {
        return ChildLogPageEnum(rawValue: currentIndex) ?? .selectMode
    }
    
    // MARK: - Initialization
    init(context: NSManagedObjectContext = CoreDataManager.shared.viewContext) {
        self.context = context
        self.canvasViewModel.onDrawingProcessed = { [weak self] image in
            guard let self else { return }
            Task { @MainActor in
                self.handleDrawingProcessed(image: image)
            }
        }
    }
    
    // MARK: - Permission
    func requestGalleryPermission(completion: @escaping (Bool) -> Void) {
        PhotoPermissionService.shared.requestPermission { [weak self] granted in
            Task { @MainActor in
                guard let self else { return }
                self.isGalleryPermissionGranted = granted
                if !granted {
                    self.showingPermissionAlert = true
                    if self.selectedMode == "Gallery" { self.selectedMode = nil }
                } else {
                    if self.selectedMode == "Gallery" {
                        completion(granted)
                    } else {
                        self.selectedMode = "Gallery"
                        completion(granted)
                    }
                }
                if !granted { completion(granted) }
            }
        }
    }
    
    // MARK: - Image Selection (Gallery Mode)
    func handleImageSelection(_ item: PhotosPickerItem?) async {
        imageLoadError = nil
        previewImage = nil
        backgroundRemover.reset()
        finalProcessedImage = nil
        
        guard let item else {
            selectedItem = nil
            return
        }
        self.selectedItem = item
        
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else {
                throw URLError(.cannotDecodeRawData)
            }
            
            previewImage = uiImage
            backgroundRemover.originalImage = uiImage
            
            await backgroundRemover.processSelectedImage(item)
            self.finalProcessedImage = backgroundRemover.resultImage
            if self.finalProcessedImage == nil {
                imageLoadError = "Failed to process the image background. Please try another photo."
            }
            
        } catch {
            previewImage = nil
            imageLoadError = "Failed to load the selected image. Please try another photo."
            backgroundRemover.reset()
            finalProcessedImage = nil
            selectedItem = nil // Clear selection on load failure
        }
    }
    
    // MARK: - Navigation Logic
    func handleNextAction(defaultAction: @escaping () -> Void) {
        switch currentPage {
        case .selectMode:
            guard selectedMode != nil else { return }
            
            if selectedMode == "Gallery" {
                if isGalleryPermissionGranted { showPhotoPicker = true }
                else {
                    requestGalleryPermission { [weak self] granted in
                        if granted { Task { @MainActor in self?.showPhotoPicker = true } }
                    }
                }
            } else if selectedMode == "Draw" {
                withAnimation { currentIndex = ChildLogPageEnum.mainInput.rawValue }
            }
            
        case .mainInput:
            if selectedMode == "Draw" {
                canvasViewModel.saveDrawing()
            } else { // Gallery Mode
                if selectedItem != nil && !backgroundRemover.isProcessing && finalProcessedImage != nil {
                    withAnimation { currentIndex = ChildLogPageEnum.finalImage.rawValue }
                } else if selectedItem == nil { imageLoadError = "Please select a photo first." }
                else if backgroundRemover.isProcessing { /* Do nothing while processing */ }
                else { imageLoadError = "Image processing failed. Try again." }
            }
            
        case .finalImage:
            defaultAction()
        }
    }
    
    func handleNoImageSelected() {
        if selectedMode == "Gallery", currentPage == .mainInput {
            withAnimation {
                currentIndex = ChildLogPageEnum.selectMode.rawValue
                selectedItem = nil
            }
        }
    }
    
    func handleDrawingProcessed(image: UIImage?) {
        print(">>> handleDrawingProcessed called with image: \(image == nil ? "nil" : "VALID")")
        guard let processed = image else {
            print(">>> ERROR: handleDrawingProcessed guard failed!")
            canvasViewModel.isProcessing = false
            // TODO: Show an alert to the user?
            return
        }
        print(">>> Guard passed, setting final image...")
        self.finalProcessedImage = processed
        print(">>> Navigating to final page...")
        withAnimation { currentIndex = ChildLogPageEnum.finalImage.rawValue }
        print(">>> Current index set to: \(currentIndex)")
    }
    
    func handleBackAction() {
        switch currentPage {
        case .finalImage:
            withAnimation {
                currentIndex = ChildLogPageEnum.mainInput.rawValue
                finalProcessedImage = nil
                if selectedMode == "Gallery" { backgroundRemover.partialReset() }
            }
        case .mainInput:
            withAnimation {
                currentIndex = ChildLogPageEnum.selectMode.rawValue
                selectedItem = nil
                backgroundRemover.reset()
            }
        case .selectMode:
            break
        }
    }
    
    func shouldDisableNext() -> Bool {
        let isModeInvalid = selectedMode == nil || selectedMode!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let isProcessingBG = backgroundRemover.isProcessing
        let isProcessingCanvas = canvasViewModel.isProcessing
        let isGalleryInputInvalid = selectedMode == "Gallery" && currentPage == .mainInput && (selectedItem == nil || finalProcessedImage == nil)
        let isDrawingInputInvalid = selectedMode == "Draw" && currentPage == .mainInput && isProcessingCanvas
        let isFinalImageInvalid = currentPage == .finalImage && finalProcessedImage == nil
        
        switch currentPage {
        case .selectMode:
            return isModeInvalid
        case .mainInput:
            if selectedMode == "Gallery" {
                return isProcessingBG || isGalleryInputInvalid
            } else { // Draw Mode
                return isDrawingInputInvalid
            }
        case .finalImage:
            return isFinalImageInvalid // Disable Done if no final image
        }
    }
    
    var shouldHideProgressBar: Bool {
        return selectedMode == "Draw" && currentPage == .mainInput
    }
}
