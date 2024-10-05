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


// Broadcaster to the single CloudResults of PropertyWrappers

// Enum to represent any kind of database change
enum DatabaseChange {
    case insert(table: String, record: [String: AnyJSON])
    case update(table: String, record: [String: AnyJSON])
    case delete(table: String, oldRecord: [String: AnyJSON])
}


//@MainActor
class SubscriptionBroadcast: ObservableObject {
    
    static let shared = SubscriptionBroadcast()

    // Generic publisher for broadcasting any change
    var changePublisher = PassthroughSubject<DatabaseChange, Never>()

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
            print("Global change detected")
            processChange(change)
        }
    }
    
    // Process any database change and broadcast it generically
        func processChange(_ change: AnyAction) {
            switch change {
            case .insert(let action):
                guard let table = action.rawMessage.payload["data"]?.objectValue?["table"]?.stringValue else { return }
                changePublisher.send(.insert(table: table, record: action.record))
                
            case .update(let action):
                guard let table = action.rawMessage.payload["data"]?.objectValue?["table"]?.stringValue else { return }
                changePublisher.send(.update(table: table, record: action.record))
                
            case .delete(let action):
                guard let table = action.rawMessage.payload["data"]?.objectValue?["table"]?.stringValue else { return }
                changePublisher.send(.delete(table: table, oldRecord: action.oldRecord))
                
            case .select(_):
                break
            }
        }
    
}
