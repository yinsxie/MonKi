//
//  GalleryHandler.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import Foundation
import PhotosUI

public class PhotoPermissionService {
    static let shared = PhotoPermissionService()
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                completion(newStatus == .authorized)
            }
        case .authorized, .limited:
            completion(true)
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
}
