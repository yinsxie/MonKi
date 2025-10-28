//
//  BgRemoverViewModel.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 28/10/25.
//

import SwiftUI
import PhotosUI

internal final class BackgroundRemoverViewModel: ObservableObject {
    @Published var originalImage: UIImage?
    @Published var resultImage: UIImage?
    @Published var alert: AlertType?
    @Published var isProcessing = false
    
    private let processor = BackgroundRemoverProcessor()
    
    enum AlertType: Identifiable {
        case error(String), success(String)
        var id: String { message }
        var title: String {
            switch self { case .error: "Error"
                case .success: "Sukses" }
        }
        var message: String {
            switch self { case .error(let message), .success(let message): return message }
        }
    }
    
    func reset() {
        Task { @MainActor in
            originalImage = nil
            resultImage = nil
            alert = nil
            isProcessing = false
        }
    }
    
    func partialReset() {
        Task { @MainActor in
            originalImage = nil
            alert = nil
            isProcessing = false
        }
    }
    
    func processSelectedImage(_ item: PhotosPickerItem?) async {
        guard let item = item,
              let data = try? await item.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: data) else {
            await showError("image_load_failed")
            return
        }
        
        await MainActor.run { originalImage = uiImage }
        await removeBackground()
    }
    
    private func removeBackground() async {
        guard originalImage != nil else {
            await showError("select_image_error")
            return
        }
        
        await MainActor.run { isProcessing = true }
        
        do {
            let result = try await processor.process(originalImage!)
            await MainActor.run {
                self.resultImage = result
                self.isProcessing = false
            }
        } catch {
            await showError("processing_error: \(error.localizedDescription)")
        }
    }
    
    private func showError(_ key: String) async {
        await MainActor.run {
            let aMessage: String
            if key == "image_load_failed" {
                aMessage = "Gagal memuat gambar. Silakan coba foto lain."
            } else if key == "select_image_error" {
                aMessage = "Silakan pilih gambar terlebih dahulu."
            } else if key.starts(with: "processing_error:") {
                aMessage = String(key.dropFirst("processing_error: ".count))
            } else {
                aMessage = "Terjadi kesalahan tidak dikenal."
            }
            alert = .error(aMessage)
            isProcessing = false
        }
    }
}
