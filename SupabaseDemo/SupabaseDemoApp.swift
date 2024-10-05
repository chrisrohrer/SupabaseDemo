//
//  SupabaseDemoApp.swift
//  SupabaseDemo
//
//  Created by Christoph Rohrer on 28.09.24.
//

import SwiftUI

@main
struct SupabaseDemoApp: App {
    
    @StateObject var authVM = AuthVM()
//    let subscribeVM = SubscriptionManager.shared

//    @StateObject var books = BooksVM()
//    @StateObject var authors = AuthorsVM()

    var body: some Scene {
        WindowGroup {
            AuthView()
                .environmentObject(authVM)
//                .environmentObject(books)
//                .environmentObject(authors)
        }
        
        .commands {
            SidebarCommands()
            
            CommandGroup(after: .saveItem) {

                Button("Logout") {
                    authVM.signOut()
                }
                .keyboardShortcut("l", modifiers: .command)
                
                Divider()
            }
        }

    }
}
