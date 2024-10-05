//
//  ContentView.swift
//  SupabaseDemo
//
//  Created by Christoph Rohrer on 28.09.24.
//

import SwiftUI

struct ContentView: View {
    
    enum Ansicht {
        case books
        case authors
    }
    
    @State private var ansicht: Ansicht = .books
    
    var body: some View {
        VStack {
            switch ansicht {
            case .books:
                BookListView()
            case .authors:
                AuthorListView()
            }
        }
        .toolbar {
            ToolbarItemGroup {
                Picker("Ansicht", selection: $ansicht) {
                    Text("Autoren").tag(Ansicht.authors)
                    Text("Bücher").tag(Ansicht.books)
                }
                .pickerStyle(.segmented)
            }
            
            ToolbarItemGroup {
                Button("Create Data") {
//                    for author in authorsVM.items {
//                        for nr in 1..<10 {
//                            Task {
//                                await booksVM.create(title: "Testbuch \(nr)", pages: nr * 7, author: author.id)
//                            }
//                        }
//                    }
                }
                Button("Delete") {
//                    booksVM.items
//                        .filter { $0.title.contains("Testbuch") }
//                        .compactMap { $0.id }
//                        .forEach { booksVM.delete(id: $0) }
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
}
