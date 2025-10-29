//
//  FieldCardView.swift
//  MonKi
//
//  Created by William on 29/10/25.
//
import SwiftUI

enum FieldState {
    case empty
    case created
    case approved
    case needToTalk
    case declined
    case done
}

struct FieldCardView: View {
    
    var type: FieldState
    @ObservedObject var gardenViewModel: GardenViewModel
    @ObservedObject var context: NavigationManager
    let size: CGFloat = 141.0
    
    var body: some View {
        ZStack {
            Image(GardenImageAsset.gardenEmptyField.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .onTapGesture {
                    if type == .empty {
                        gardenViewModel.onFieldTapped(forFieldType: type, context: context)
                    }
                }
        }
    }
}
