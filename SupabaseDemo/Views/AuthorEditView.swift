//
//  AuthorEditView.swift
//  AuthorsDemo
//
//  Created by Christoph Rohrer on 14.09.24.
//

import SwiftUI


struct AuthorEditView: View {
    
    var author: Author? = nil
    
    @ObservedResults<Country> var countries

    @State private var inputAuthor = Author(name: "", birthyear: 1900)
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Author") {
                    TextField("Name", text: $inputAuthor.name)
                    TextField("Geburtsjahr", value: $inputAuthor.birthyear, formatter: NumberFormatter())
                }
                
                Section("Country") {
                    Picker("Country", selection: $inputAuthor.countryId) {
                        Text("no Country").tag(nil as Int?)
                        ForEach(countries) { country in
                            Text(country.name).tag(country.id as Int?)
                        }
                    }
                }

                Section("Bücher") {
                    ForEach(author?.books ?? []) { book in
                        Text(book.title)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle(author == nil ? "New Author" : "Edit Author")
        }
        .toolbar {
            if author == nil {
                ToolbarItem(placement: .cancellationAction ) {
                    Button("Abbrechen", role: .cancel) {
                        dismiss()
                    }
                }
            }
            
            ToolbarItem(placement: .confirmationAction ) {
                Button("Speichern") {
                    if author == nil {
                        inputAuthor.create()
                        dismiss()
                    } else {
                        inputAuthor.update()
                    }
                }
                .disabled(inputAuthor.name.isEmpty)
            }
        }
        .onAppear {
            if let author {
                inputAuthor = author
            }
        }
        .onChange(of: author) {
            if let author {
                inputAuthor = author
            }
        }
    }
}

#Preview {
    AuthorEditView() 
}
