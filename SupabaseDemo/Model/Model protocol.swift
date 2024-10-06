//
//  Model protocol.swift
//  SupabaseDemo
//
//  Created by Christoph Rohrer on 04.10.24.
//

import Foundation
import Realtime


protocol Model: Codable, Identifiable, Hashable {
    
    static var tableName: String { get }        // To differentiate between models
    static var relations: [String] { get }   // Array of string Names for all tables with relations

    var id: Int? { get set }

    // CRUD Operations
//    static func fetchAll() async -> [Self]
//    func create()
//    func update()
//    func delete() 
}


@propertyWrapper
struct Relation<Value>: Equatable, Hashable 
where Value: Hashable, Value: Equatable {
//    static func == (lhs: Relation<Value>, rhs: Relation<Value>) -> Bool {
//        lhs.wrappedValue == rhs.wrappedValue
//    }
    
    var wrappedValue: Value

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

@propertyWrapper
struct ForeignKey<Value>: Equatable, Hashable
where Value: Hashable, Value: Equatable {
    var wrappedValue: Value

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}



extension Model {
    
    // MARK: - fetch
    
    // create fecth string from relations
    static var fetchRelations: String {
        let result = relations.reduce("*") { $0 + ", \($1)(*)"}
        print(result)
        return result
    }
    
    
    static func fetchAll(sort: String?) async -> [Self] {
        do {
            let result: [Self] = try await supabase
                .from(Self.tableName)
                .select(fetchRelations)
                .order(sort ?? "created_at", ascending: true)
                .execute()
                .value
            
                print("Model fetched", Self.tableName)
                return(result)
        } catch {
            print("Model fetch Error:", Self.tableName, error.localizedDescription)
            return []
        }
    }
        
    
    static func fetchById(_ id: Int) async -> Self? {
        do {
            let result: [Self] = try await supabase
                .from(Self.tableName)
                .select(fetchRelations)
                .eq("id", value: id)
                .execute()
                .value
            
                print("Model by ID fetched", Self.tableName)
            return(result.first)
        } catch {
            print("Model by ID fetch Error:", Self.tableName, error.localizedDescription)
            return nil
        }
    }

    
    
    // MARK: - CRUD
    
    // Default implementation for create
    func create() {
        Task {
            do {
                let _ = try await supabase
                    .from(Self.tableName)
                    .insert(self)
                    .execute()
            } catch {
                print("Model create Error:", Self.tableName, error.localizedDescription)
            }
        }
    }

    // Default implementation for update
    func update() {
        guard let idValue = self.id else {
            print("Model update Error: Invalid ID")
            return
        }

        Task {
            do {
                try await supabase
                    .from(Self.tableName)
                    .update(self)
                    .eq("id", value: idValue)
                    .execute()
                print("update written")
            } catch {
                print("Model update Error:", Self.tableName, error.localizedDescription)
            }
        }
    }

    // Default implementation for delete
    func delete() {
        guard let idValue = self.id else {
            print("Model delete Error: Invalid ID")
            return
        }

        Task {
            do {
                try await supabase
                    .from(Self.tableName)
                    .delete()
                    .eq("id", value: idValue)
                    .execute()
            } catch {
                print("Model delete Error:", Self.tableName, error.localizedDescription)
            }
        }
    }
}
