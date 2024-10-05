//
//  ViewModel.swift
//  SupaFeatures
//
//  Created by Mikaela Caron on 7/23/23.
//

import Foundation
import Supabase
import Realtime


@MainActor
final class BookVM: ObservableObject {
    
    @Published var book: Book
    @Published var author: Author?
    
    init(book: Book) {
        self.book = book
        Task {
            await loadAuthor() // Load the author for this book
        }
    }
    
    
    func loadAuthor() async {
        do {
            let author: Author = try await supabase
                .from(Author.tableName)
                .select()
                .eq("id", value: book.authorId) // Match the id in the authors table
                .execute()
                .value
            
            DispatchQueue.main.async {
                self.author = author
            }
        } catch {
            print("error loading author", error.localizedDescription)
        }
    }
    
}
