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
    @Published var inputSelectedMode: String?
    @Published var tagSelectedMode: String?
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
    
    // MARK: - Inject Beneficial Tag dummy data
    @Published var beneficialTagsString: String = "Sehat;Senang;Kuat;Cepat;Baru;Lama"
        
    var beneficialTagLabels: [String] {
        return IOHelper.expandTags(beneficialTagsString)
    }
    
    @Published var selectedBeneficialTags = Set<BeneficialTag>()
    
    // MARK: - Computed Properties
    
    private var inputFlowPageCount: Int {
        ChildLogPageEnum.allCases.count
    }
    
    var totalPageCount: Int {
        ChildLogPageEnum.allCases.count + ChildLogTagEnum.allCases.count
    }

    var currentInputPage: ChildLogPageEnum? {
        guard currentIndex < inputFlowPageCount else { return nil }
        return ChildLogPageEnum(rawValue: currentIndex)
    }
    
    var currentTagPage: ChildLogTagEnum? {
        guard currentIndex >= inputFlowPageCount else { return nil }
        return ChildLogTagEnum(rawValue: currentIndex)
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
                    if self.inputSelectedMode == "Gallery" { self.inputSelectedMode = nil }
                } else {
                    if self.inputSelectedMode == "Gallery" {
                        completion(granted)
                    } else {
                        self.inputSelectedMode = "Gallery"
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
        
        guard currentIndex < totalPageCount - 1 else {
            // TODO: Panggil fungsi saveLog di sini
            print("Navigasi selesai, panggil defaultAction (close)")
            defaultAction() // Tutup navigasi
            return
        }
        
        if let inputPage = currentInputPage {
            switch inputPage {
            case .selectMode:
                guard inputSelectedMode != nil else { return }
                
                if inputSelectedMode == "Gallery" {
                    if isGalleryPermissionGranted { showPhotoPicker = true }
                    else {
                        requestGalleryPermission { [weak self] granted in
                            if granted { Task { @MainActor in self?.showPhotoPicker = true } }
                        }
                    }
                } else if inputSelectedMode == "Draw" {
                    withAnimation { currentIndex = ChildLogPageEnum.mainInput.rawValue }
                }
                
            case .mainInput:
                if inputSelectedMode == "Draw" {
                    canvasViewModel.saveDrawing()
                } else { // Gallery Mode
                    if selectedItem != nil && !backgroundRemover.isProcessing && finalProcessedImage != nil {
                        withAnimation { currentIndex = ChildLogPageEnum.finalImage.rawValue }
                    } else if selectedItem == nil { imageLoadError = "Please select a photo first." }
                    else if backgroundRemover.isProcessing { /* Do nothing while processing */ }
                    else { imageLoadError = "Image processing failed. Try again." }
                }
                
            case .finalImage:
                print("Lanjut dari .finalImage ke .howHappy")
                withAnimation { currentIndex += 1 }
            }
        }
        else if let tagPage = currentTagPage {
            // TODO: Tambahkan validasi jika perlu
            print("Lanjut dari \(tagPage) ke halaman berikutnya")
            withAnimation { currentIndex += 1 }
        }
    }
    
    func handleNoImageSelected() {
        if inputSelectedMode == "Gallery", currentInputPage == .mainInput {
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
        guard currentIndex > 0 else { return }

        withAnimation { currentIndex -= 1 }
        
        if currentInputPage == .finalImage {
            tagSelectedMode = nil
            selectedBeneficialTags.removeAll()
        }
        else if currentInputPage == .mainInput {
            finalProcessedImage = nil
            if inputSelectedMode == "Gallery" { backgroundRemover.partialReset() }
        }
        else if currentInputPage == .selectMode { // Kembali ke .selectMode (indeks 0)
            // (Reset state jika ada)
        }
    }
    
    func shouldDisableNext() -> Bool {
        if let inputPage = currentInputPage {
            switch inputPage {
            case .selectMode:
                return inputSelectedMode == nil || inputSelectedMode!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            case .mainInput:
                if inputSelectedMode == "Gallery" {
                    return backgroundRemover.isProcessing || (selectedItem == nil || finalProcessedImage == nil)
                } else { // Draw Mode
                    return canvasViewModel.isProcessing
                }
            case .finalImage:
                return finalProcessedImage == nil
            }
        } else if let tagPage = currentTagPage {
            // TODO: Tambahkan validasi untuk halaman tag
            switch tagPage {
            case .howHappy:
                // Contoh: return tagSelectedMode == nil
                return false // Izinkan lanjut untuk sekarang
            case .happyIllust:
                return false // Izinkan lanjut untuk sekarang
            case .howBeneficial:
                // Contoh: return selectedBeneficialTags.isEmpty
                return false // Izinkan lanjut untuk sekarang
            }
        }
        return false // Default
    }
    
    var shouldHideProgressBar: Bool {
        return inputSelectedMode == "Draw" && currentInputPage == .mainInput
    }
}
