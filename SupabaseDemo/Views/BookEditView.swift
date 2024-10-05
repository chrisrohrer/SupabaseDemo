//
//  BookEditView.swift
//  BooksDemo
//
//  Created by Christoph Rohrer on 14.09.24.
//

import SwiftUI


struct BookEditView: View {
    
    var book: Book? = nil
    
    @ObservedResults<Author> var authors

    @State private var inputBook = Book(title: "", pages: 0)
    
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Book") {
                    TextField("Title", text: $inputBook.title)
                    TextField("Pages", value: $inputBook.pages, formatter: NumberFormatter())
                }
                Section("Author") {
                    Picker("Author", selection: $inputBook.authorId) {
                        Text("no Author").tag(nil as Int?)
                        ForEach(authors) { author in
                            Text(author.name).tag(author.id as Int?)
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle(book == nil ? "New Book" : "Edit Book")
        }
        .toolbar {
            if book == nil {
                ToolbarItem(placement: .cancellationAction ) {
                    Button("Abbrechen", role: .cancel) {
                        dismiss()
                    }
                }
            }
            
            ToolbarItem(placement: .confirmationAction ) {
                Button("Speichern") {
                    if let book {
                        inputBook.update()
//                        Task {
//                            await booksVM.update(book, title: inputBook.title, pages: inputBook.pages, author: inputBook.authorId )
//                        }
                    } else {
                        inputBook.create()
//                        Task {
//                            await booksVM.create(title: inputBook.title, pages: inputBook.pages, author: inputBook.authorId)
//                        }
                        dismiss()
                    }
                }
                .disabled(inputBook.title.isEmpty || inputBook.pages == 0 )
            }
        }
        
        .onAppear {
            if let book {
                inputBook = book
            }
        }
        .onChange(of: book) {
            if let book {
                inputBook = book
            }
        }
    }
}

#Preview {
    BookEditView() 
}
