//
//  ObservedResults.swift
//  SupabaseDemo
//
//  Created by Christoph Rohrer on 04.10.24.
//

import Foundation
import SwiftUI
import Combine
import Realtime
import HelpersLibrary


// Fetch Manager that handles fetching data asynchronously
final class CloudResults<T: Model>: ObservableObject {
    
    var sort: String?
    
    @Published var items: [T] = []
    
    @Published var isLoading = true
    @Published var error: Error?

    private var cancellables = Set<AnyCancellable>()

    init(sort: String?) {
        print("CloudResults init", T.tableName)
        self.sort = sort
        subscribeToChanges()
        Task {
            await fetchData()
        }
    }

    // Fetch data asynchronously
    func fetchData() async {
        let result = await T.fetchAll(sort: sort)
        DispatchQueue.main.async {
            self.items = result
            self.isLoading = false
        }
    }
    
    
    private func subscribeToChanges() {
        SubscriptionBroadcast.shared.changePublisher
            .sink { [weak self] change in
                self?.handleChange(change: change)
            }
            .store(in: &cancellables)
    }

    
    private func handleChange(change: DatabaseChange) {
        
//        print("*** change detected", change)

        switch change {
            
        case .insert(let table, let record):
            guard table == T.tableName else { return }
            print("*** insert", T.self, record["id"] as Any)

            if let record = try? record.decode(as: T.self) {
                print("*** decoded")
                DispatchQueue.main.async {
                    self.items.append(record)
                }
            }

            
        case .update(let table, let record):
            guard table == T.tableName else { return }
            print("*** update", T.self, record["id"] as Any)

            Task {
                if let recordId = record["id"]?.intValue,
                   let record = await T.fetchById(recordId) {
                    if let index = self.items.firstIndex(where: { $0.id == recordId }) {
                        DispatchQueue.main.async {
                            self.items[index] = record
                        }
                    }
                }
            }

        case .delete(let table, let oldRecord):
            guard table == T.tableName else { return }
            print("*** delete", oldRecord["id"] as Any)

            if let recordId = oldRecord["id"]?.intValue {
                DispatchQueue.main.async {
                    self.items.removeAll(where: { $0.id == recordId })
                }
            }

        }
    }

    
    /*
    func subscribe() async {

        print("Model subscribing...", T.tableName )
        
        self.channel = supabase.channel(T.tableName)
        let changes = channel!.postgresChange(AnyAction.self, schema: "public")
        await channel!.subscribe()

        for await change in changes {
            print("*** change detected", T.tableName)
            switch change {
            case .insert(let action): 
                print("*** insert", action.record["id"])
                if let record = try? action.record.decode(as: T.self) {
                    print("*** decoded")
                    DispatchQueue.main.async {
                        self.items.append(record)
                    }
                }
                
            case .update(let action):
                print("*** update",T.self, action.record["id"])
//                if let record = try? action.record.decode(as: T.self) {
//                    print("*** decoded")
//                    if let recordId = record.id, let index = self.items.firstIndex(where: { $0.id == recordId }) {
//                        DispatchQueue.main.async {
//                            self.items[index] = record
//                        }
//                    }
//                }
                if let recordId = action.record["id"]?.intValue,
                    let record = await T.fetchById(recordId) {
                    if let index = self.items.firstIndex(where: { $0.id == recordId }) {
                        DispatchQueue.main.async {
                            self.items[index] = record
                        }
                    }
                }

            case .delete(let action):
                print("*** delete", action.oldRecord["id"])
                if let recordId = action.oldRecord["id"]?.intValue {
                    DispatchQueue.main.async {
                        self.items.removeAll(where: { $0.id == recordId })
                    }
                }
                
            case .select(let action):
                print("select?", action.record)
            }
//            await fetchData()
        }
    }
     */

}



// Property wrapper that wraps the FetchAllManager
@propertyWrapper
struct ObservedResults<T: Model>: DynamicProperty {
    
    init(sort: String? = nil) {
        self._cloudResults = StateObject(wrappedValue: CloudResults<T>(sort: sort))
    }
    
    @StateObject private var cloudResults: CloudResults<T>

    var wrappedValue: [T] {
        return cloudResults.items
    }

    var projectedValue: CloudResults<T> {
        return cloudResults
    }
}




