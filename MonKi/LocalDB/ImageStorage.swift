//
//  ImageStorage.swift
//  MonKi
//
//  Created by William on 27/10/25.
//

import Foundation
import UIKit

struct ImageStorage {
    static func saveImage(_ image: UIImage) -> String? {
        guard let data = image.pngData() else {
            return nil
        }
        
        let id = UUID().uuidString
        
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(id).png")
        
        do {
            try data.write(to: fileURL)
            return fileURL.path // store this string into Core Data
        } catch {
            print("Error saving image:", error)
            return nil
        }
    }
    
    static func loadImage(from path: String) -> UIImage? {
        let url = URL(fileURLWithPath: path)
        return UIImage(contentsOfFile: url.path)
    }
    
    private static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
