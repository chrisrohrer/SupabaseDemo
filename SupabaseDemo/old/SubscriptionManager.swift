//
//  ViewModel.swift
//  SupaFeatures
//
//  Created by Mikaela Caron on 7/23/23.
//

import Foundation
import Supabase
import Realtime
import Combine


let subscriptionTypes: [String: Decodable.Type] = [
    "Authors": Author.self,
    "Books": Book.self
]


@MainActor
class SubscriptionManager: ObservableObject {
    
    static let shared = SubscriptionManager()

    @Published var authors: [Author] = []
    @Published var books: [Book] = []

    private var subscriptions = Set<AnyCancellable>()

    init() {
        Task {
            await subscribeToChanges()
        }
    }

    
    // MARK: - Subscribe
    
    func subscribeToChanges() async {
        
        print("Global subscribing...")
        
        let myChannel = supabase.channel("realtime changes")
        let changes = myChannel.postgresChange(AnyAction.self, schema: "public")
        await myChannel.subscribe()
        
        for await change in changes {
            
            switch change {
                
            case .insert(let action):
                let table = action.rawMessage.payload["data"]?.objectValue?["table"]?.stringValue ?? "?"
                print("Global insert", table)
                

            case .update(let action):
                print("update", action.record)
                let table = action.rawMessage.payload["data"]?.objectValue?["table"]?.stringValue ?? "?"
                print("Global update", table)

//                guard let objectType = subscriptionTypes[table] else { return }
                
                
            case .delete(let action):
                print("delete", action.oldRecord)
                let table = action.rawMessage.payload["data"]?.objectValue?["table"]?.stringValue ?? "?"
                print("Global delete", table)

            case .select(let action): print("Global select?", action)
            }
        }
    }
    
}
