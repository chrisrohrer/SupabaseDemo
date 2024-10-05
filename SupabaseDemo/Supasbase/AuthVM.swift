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
final class AuthVM: ObservableObject {
    
    @Published var userId: UUID? = nil
        
    var isAuthenticated: Bool {
        userId != nil
    }
        
    init() {
        subscribeToAuthChanges()
    }
    
    
    // MARK: - Authentication
        
    func subscribeToAuthChanges() {
        Task {
            for await state in supabase.auth.authStateChanges {
              if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                  self.userId = state.session?.user.id
//                isAuthenticated = state.session != nil
                  print("Users Auth changed:", state.event, isAuthenticated)
              }
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Task {
            do {
                _ = try await supabase.auth.signIn(email: email, password: password)
            } catch {
                print(#function, error.localizedDescription)
            }
        }
    }
        
    func signOut() {
        Task {
            do {
                try await supabase.auth.signOut()
            } catch {
                print(#function, error.localizedDescription)
            }
        }
    }
    
}
