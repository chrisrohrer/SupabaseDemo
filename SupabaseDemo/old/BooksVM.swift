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
final class BooksVM: ObservableObject {
    
    @Published var items: [Book] = []
    
    init() {
        Task {
            await fetchAll()
            await subscribe()
        }
    }

    
    func fetchAll() async {
        do {
            /* // Kontrolle des geladenen JSON vor Encode
            let result = try await supabase
                .from(Book.tableName)
                .select("*, Authors(*)")
                .execute()
                .string()
            
            print("Books result", result)
            */
            let books: [Book] = try await supabase
                .from(Book.tableName)
                .select("*, Authors(*)")
                .order("title", ascending: true)
                .execute()
                .value
            
            DispatchQueue.main.async {
                print("fetched Books")
                self.items = books
            }
        } catch {
            print("Books fetch", error.localizedDescription)
        }
    }
    
    
    // MARK: - Subscribe
    
    func subscribe() async {

        print("subscribing...", #file )
        
        let myChannel = supabase.channel("schema-db-changes")
        let changes = myChannel.postgresChange(AnyAction.self, schema: "public")
        await myChannel.subscribe()

        for await change in changes {
            switch change {
            case .insert(let action): print("insert", action.record)
            case .update(let action): print("update", action.record, action.rawMessage.payload["data"])
            case .delete(let action): print("delete", action.oldRecord)
            case .select(let action): print("select?", action.record)
            }
//            await self.fetchAll()
        }
    }

    func localUpdate(_ book: Book) {
        
    }
    
    
    

    // MARK: - Database
    
    func create(title: String, pages: Int, author: Author.ID) async {
        let book = Book(title: title, pages: pages, authorId: author)
        do {
            let _ = try await supabase
                .from(Book.tableName)
                .insert(book)
                .execute()
            
            await fetchAll()
        } catch {
            print("Books create", error.localizedDescription)
        }
    }
    
    
    func update(_ book: Book, title: String, pages: Int, author: Author.ID) async {
        guard let id = book.id else {
            print("❌ Can't update feature \(book)")
            return
        }
        
        var toUpdate = book
        toUpdate.title = title
        toUpdate.pages = pages
        toUpdate.authorId = author
        
        do {
            try await supabase
                .from(Book.tableName)
                .update(toUpdate)
                .eq("id", value: id)
                .execute()
            
            await fetchAll()
        } catch {
            print("❌ Error: \(error)")
        }
    }
    
    func delete(id: Int) {
        
        Task {
            do {
                try await supabase
                    .from(Book.tableName)
                    .delete()
                    .eq("id", value: id)
                    .execute()
                
                await fetchAll()
            } catch {
                print("❌ Error: \(error)")
            }
        }
    }
    
}
