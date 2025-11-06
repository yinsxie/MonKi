//
//  ChildLogViewModel.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import SwiftUI
import PhotosUI
import CoreData
import Combine

@MainActor
final class ChildLogViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Navigation & State
    @Published var currentIndex: Int = 0
    @Published var inputSelectedMode: String?
    @Published var hasSlide: Bool = false
    @Published var happyLevel: Int = 0
    @Published var isGalleryPermissionGranted: Bool = false
    @Published var showingPermissionAlert: Bool = false
    //    @Published var isShowGardenFullAlert: Bool = false
    @Published var activePopup: LogInputModality? = nil
    
    var isNextDisabled: Bool {
        if let inputPage = currentInputPage {
            switch inputPage {
            case .selectMode:
                let text = (inputSelectedMode ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                return text.isEmpty
            case .mainInput:
                if inputSelectedMode == "Gallery" {
                    return backgroundRemover.isProcessing || selectedItem == nil || finalProcessedImage == nil
                } else {
                    // Draw mode
                    return canvasViewModel.isProcessing || !canvasViewModel.isExistDrawing
                }
            case .finalImage:
                return finalProcessedImage == nil
            }
        } else if let tagPage = currentTagPage {
            switch tagPage {
            case .howHappy: return !hasSlide
                //                    case .happyIllust: return false
            case .howBeneficial: return false
            }
        }
        return false
    }
    
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
    @Published var logs: [MsLog] = []
    var logRepo: LogRepositoryProtocol
    var parentValueTagRepo: ParentValueTagRepositoryProtocol
    
    // MARK: - Beneficial Tag
    //    @Published var beneficialTagsString: String = "Sehat;Pintar;Kuat;Cepat;Baru;Lama"
    @Published var beneficialTagsString: String = ""
    
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
        // Map to tag page by offsetting from the input flow count (robust even if enum rawValues change)
        let tagIndex = currentIndex - inputFlowPageCount
        return ChildLogTagEnum(rawValue: tagIndex)
    }
    
    var monkiImageName: String {
        switch self.happyLevel {
        case 0:
            return "monki_default"
        case 1:
            return "monki_happy"
        case 2:
            return "monki_veryhappy"
        default:
            return "monki_default"
        }
    }
    
    var sliderImage: UIImage {
        if let image = finalProcessedImage {
            return image
        } else {
            return UIImage(named: "IceCreamIcon") ?? UIImage(systemName: "face.smiling.fill") ?? UIImage()
        }
    }
    
    //    var isHappy: Bool {
    //        return tagSelectedMode == "Happy"
    //    }
    
    var isBeneficial: Bool {
        return !selectedBeneficialTags.isEmpty
    }
    
    var beneficialTags: [String] {
        let allLabels = self.beneficialTagLabels
        let allShapes = BeneficialTag.allCases
        let tagMap = Dictionary(uniqueKeysWithValues: zip(allShapes, allLabels))
        let selectedLabels = selectedBeneficialTags.compactMap { selectedTag in
            return tagMap[selectedTag]
        }
        return selectedLabels
    }
    
    
    // MARK: - Initialization
    init(logRepo: LogRepositoryProtocol = LogRepository()) {
        self.logRepo = logRepo
        self.parentValueTagRepo = ParentValueTagRepository()
        
        canvasViewModel.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
        
        self.canvasViewModel.onDrawingProcessed = { [weak self] image in
            guard let self else { return }
            Task { @MainActor in
                self.handleDrawingProcessed(image: image)
            }
        }
        
        self.$happyLevel
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                // Setiap kali 'happyLevel' berubah,
                // atur 'hasSlide' menjadi true.
                print("happyLevel changed, setting hasSlide = true")
                self?.hasSlide = true
            }
            .store(in: &cancellables)
        
        fetchBeneficialTags()
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
    func handleNextAction(context: NavigationManager, defaultAction: @escaping () -> Void) {
        guard currentIndex < totalPageCount - 1 else {
            
            let isGardenFull = UserDefaultsManager.shared.isFieldMaxedOut()
            
            saveLog()
            self.activePopup = .withParent(
                onPrimaryTap: {
                    print("With Parent: Yes")
                    context.popLast()
                    context.goTo(.parentGate)
                },
                onSecondaryTap: {
                    print("With Parent: No")
                    context.popToRoot()
                }
            )
            return
        }
        
        if let inputPage = currentInputPage {
            handleInputFlowNext(for: inputPage)
        } else if let tagPage = currentTagPage {
            handleTagFlowNext(for: tagPage)
        }
    }
    
    private func handleInputFlowNext(for page: ChildLogPageEnum) {
        switch page {
        case .selectMode:
            handleSelectModeNext()
        case .mainInput:
            handleMainInputNext()
        case .finalImage:
            print("Lanjut dari .finalImage ke .howHappy")
            withAnimation { currentIndex += 1 }
        }
    }
    
    private func handleSelectModeNext() {
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
    }
    
    private func handleMainInputNext() {
        if inputSelectedMode == "Draw" {
            canvasViewModel.saveDrawing()
        } else { // Gallery Mode
            if selectedItem != nil && !backgroundRemover.isProcessing && finalProcessedImage != nil {
                withAnimation { currentIndex = ChildLogPageEnum.finalImage.rawValue }
            } else if selectedItem == nil {
                imageLoadError = "Please select a photo first."
            } else if backgroundRemover.isProcessing {
            } else {
                imageLoadError = "Image processing failed. Try again."
            }
        }
    }
    
    private func handleTagFlowNext(for page: ChildLogTagEnum) {
        switch page {
        case .howHappy: break
        case .howBeneficial:
            break
        }
        withAnimation { currentIndex += 1 }
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
            hasSlide = false
            selectedBeneficialTags.removeAll()
        } else if currentInputPage == .mainInput {
            finalProcessedImage = nil
            if inputSelectedMode == "Gallery" { backgroundRemover.partialReset() }
        } else if currentInputPage == .selectMode { // Kembali ke .selectMode (indeks 0)
            // (Reset state jika ada)
        }
    }
    
    var shouldHideProgressBar: Bool {
        return inputSelectedMode == "Draw" && currentInputPage == .mainInput
    }
    
    private func saveLog() {
        
        guard let imageToSave = finalProcessedImage else {
            print("Error: 'finalProcessedImage' nil saat mencoba menyimpan.")
            return
        }
        logRepo.createLogOnly(imageToSave, happyLevel: self.happyLevel, tags: self.beneficialTags)
        UserDefaultsManager.shared.incrementCurrentFilledField(by: 1)
        //
        //        logRepo.createLogWithImage(
        //            imageToSave,
        //            isHappy: true,
        //            happyLevel: self.happyLevel,
        //            isBeneficial: self.isBeneficial,
        //            tags: self.beneficialTags
        //        )
        //
        //        UserDefaultsManager.shared.incrementCurrentFilledField(by: 1)
    }
    
    // MARK: ini buat di app store, jadi saya simpan dulu
    //    func setAlertonGardenFull(to value: Bool) {
    //        isShowGardenFullAlert = value
    //    }
    
    func dismissActivePopup() {
        activePopup = nil
    }
    
    private func fetchBeneficialTags() {
        let fetched = parentValueTagRepo.fetchAllParentValueTags().first?.valueTag?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !fetched.isEmpty {
            self.beneficialTagsString = fetched
        } else {
            print("LOG: No ParentValueTag found in Core Data.")
        }
    }
}
