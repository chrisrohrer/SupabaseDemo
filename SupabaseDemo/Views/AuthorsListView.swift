//
//  ContentView.swift
//  AuthorsDemo
//
//  Created by Christoph Rohrer on 14.09.24.
//

import SwiftUI
import HelpersLibrary

struct AuthorListView: View {
    
    @ObservedResults<Author> var authors

    @State private var selectedAuthor: Author.ID?
    @State private var addSheet = false

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedAuthor) {
                ForEach(authors) { author in
                    VStack(alignment: .leading) {
                        AuthorCellView(author: author)
                            .contextMenu {
                                Button("Delete") {
                                    author.delete()
                                }
                            }
                    }
                }
            }

        } detail: {
            if let author = authors[selectedAuthor] {
                AuthorEditView(author: author)
            }
        }
        .navigationTitle("Authors")
        .toolbar {
            ToolbarItem(placement: .primaryAction ) {
                Button("Add Author", systemImage: "plus") { addSheet = true }
            }
        }
        .sheet(isPresented: $addSheet, content: {
            AuthorEditView() 
        })
        
    }
}



struct AuthorCellView: View {
    
    let author: Author
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(author.name)
                .font(.headline)
            HStack {
                Text(author.birthyear.formatted())
                Text(author.country?.name ?? "?")
            }
                .font(.subheadline)
//            Text(author?.name ?? "?")
//                .font(.subheadline)
        }
    }
}






#Preview {
    ContentView()
}
