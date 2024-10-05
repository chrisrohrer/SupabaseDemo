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
final class AuthorVM: ObservableObject {
    
    @Published var author: Author
    @Published var books: [Book]?
    
    init(author: Author) {
        self.author = author
        Task {
            await loadBooks() // Load the author for this book
        }
    }
    
    
    func loadBooks() async {
        do {
            let books: [Book] = try await supabase
                .from(Book.tableName)
                .select()
                .eq("author_id", value: author.id) // Match the id in the authors table
                .execute()
                .value
            
            DispatchQueue.main.async {
                self.books = books
            }
        } catch {
            print("error loading author", error.localizedDescription)
        }
    }
    
}
