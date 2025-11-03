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
            VStack(spacing: 0) { // Set spacing to 0
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
                .padding(.bottom, 8) // Add a little space below input
                
                // <<< ADDED SECTION: SUGGESTIONS >>>
                // Only show this section if there are suggestions available
                if !viewModel.availableSuggestions.isEmpty {
                    VStack(spacing: 0) {
                        Text("Suggestions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.bottom, 4)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.availableSuggestions, id: \.self) { suggestion in
                                    Button(action: {
                                        viewModel.addTagFromSuggestion(suggestion)
                                    }) {
                                        Text(suggestion)
                                            .font(.callout)
                                    }
                                    .buttonStyle(.bordered)
                                    .clipShape(Capsule())
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 8) // Space before the list
                    }
                }
                // <<< END OF ADDED SECTION >>>
                
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
    // Wrap in a NavigationView for the preview to look correct
    NavigationView {
        ParentValueTagView()
    }
}
