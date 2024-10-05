//
//  Secrets.swift
//  SupaFeatures
//
//  Created by Mikaela Caron on 7/23/23.
//

import Foundation
import Supabase

enum Secrets {
    static let projectURL = URL(string: "https://kxfxqhhjhazjcoelgvln.supabase.co")!
        
    static let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt4ZnhxaGhqaGF6amNvZWxndmxuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc1MTgwMDIsImV4cCI6MjA0MzA5NDAwMn0.7adOiWmiJ1SrUheQA9oBA8fpkQUwjJE3TLOrA89NdKU"
}

let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)
