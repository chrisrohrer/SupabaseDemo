//
//  ContentView.swift
//  BooksDemo
//
//  Created by Christoph Rohrer on 14.09.24.
//

import SwiftUI

struct BookListView: View {
    
    @ObservedResults<Book>(sort: "title") var books
    
    @State private var selectedBook: Book.ID?
    @State private var addSheet = false

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedBook) {
                ForEach(books) { book in
                    VStack(alignment: .leading) {
                        BookCellView(book: book)
                            .contextMenu {
                                Button("Delete") {
                                    book.delete()
                                }
                            }
                    }
                }
            }

        } detail: {
            if let book = books[selectedBook] {
                BookEditView(book: book)
            }
        }
        .navigationTitle("Books")
        .toolbar {
            ToolbarItem(placement: .primaryAction ) {
                Button("Add Book", systemImage: "plus") { addSheet = true }
            }
        }
        .sheet(isPresented: $addSheet, content: {
            BookEditView() 
        })
        
    }
}



struct BookCellView: View {
    
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
                .font(.headline)
            HStack {
                Text(book.author?.name ?? "?")
                Text(book.pages.formatted())
            }
            .font(.subheadline)
        }
    }
}






#Preview {
    ContentView()
}
