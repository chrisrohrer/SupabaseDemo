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
final class AuthorsVM: ObservableObject {
    
    @Published var items: [Author] = []
    
    init() {
        Task {
            await fetchAll()
//            await subscribe()
        }
    }

    
    func fetchAll() async {
        do {
            let authors: [Author] = try await supabase
                .from(Author.tableName)
                .select("*, Books(*)")
                .order("name", ascending: true)
                .execute()
                .value
            
            DispatchQueue.main.async {
                print("fetched Authors")
                self.items = authors
            }
        } catch {
            print("Authors fetch", error.localizedDescription)
        }
    }
    
    // MARK: - Subscribe
    
    func subscribe() async {

        print("subscribing...")
        
        let myChannel = supabase.channel("schema-db-changes")
        let changes = myChannel.postgresChange(AnyAction.self, schema: "public")
        await myChannel.subscribe()

        for await change in changes {
          switch change {
          case .insert(let action): print("insert", action.record)
          case .update(let action): print("update", action.record, action.rawMessage.payload["data"])
          case .delete(let action): print("delete", action.oldRecord)
          case .select(let action): print("select?")
          }
            await self.fetchAll()
        }
    }


    // MARK: - Database
    
    func create(name: String, birthyear: Int) async throws {
        let author = Author(name: name, birthyear: birthyear, books: [])
        
        do {
            let _ = try await supabase
                .schema("public")
                .from(Author.tableName)
                .insert(author)
                .execute()
            
            await fetchAll()
        } catch {
            print(#function, error.localizedDescription)
        }
    }
    
    
    func update(_ author: Author, name: String, birthyear: Int) async {
        guard let id = author.id else {
            print("❌ Can't update feature \(author)")
            return
        }
        
        var toUpdate = author
        toUpdate.name = name
        toUpdate.birthyear = birthyear
        
        do {
            try await supabase
                .from(Author.tableName)
                .update(toUpdate)
                .eq("id", value: id)
                .execute()
            
            await fetchAll()
        } catch {
            print("❌ Error: \(error)")
        }
    }
    
    func delete(at id: Int) async throws {
        try await supabase
            .from(Author.tableName)
            .delete()
            .eq("id", value: id)
            .execute()
        
        await fetchAll()
    }
    
}
