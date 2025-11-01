//
//  ParentValueView.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 01/11/25.
//

import SwiftUI

struct ParentValueTagView: View {
    
    /// The ViewModel for this view.
    @StateObject private var viewModel = ParentValueTagViewModel()
    
    var body: some View {
            VStack {
                // MARK: - Input Section
                HStack(spacing: 12) {
                    TextField("Add new value (e.g., Sehat)", text: $viewModel.newTagText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading)
                    
                    Button(action: viewModel.addNewTag) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                    .disabled(viewModel.newTagText.trimmingCharacters(in: .whitespaces).isEmpty)
                    .padding(.trailing)
                }
                .padding(.top)
                
                // MARK: - Tag List
                List {
                    ForEach(viewModel.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.headline)
                    }
                    .onDelete(perform: viewModel.deleteTag)
                }
                .listStyle(.insetGrouped)
                
            }
            .navigationTitle("Parent Values")
            .toolbar {
                // Add an Edit button to easily toggle delete mode
                EditButton()
            }
            .onAppear {
                // Load (or reload) the tags every time the view appears.
                viewModel.loadTags()
            }
    }
}

#Preview {
    ParentValueTagView()
}
