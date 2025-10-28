//
//  DrawPage.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 27/10/25.
//

import SwiftUI

struct DrawPage: View {
    var body: some View {
        Image(systemName: "pencil.and.outline")
            .resizable()
            .scaledToFit()
            .frame(height: 200)
    }
}

#Preview {
    DrawPage()
}
