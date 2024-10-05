//
//  Book.swift
//  SupabaseDemo
//
//  Created by Christoph Rohrer on 29.09.24.
//

import Foundation

struct Author: Model {
    
    
    static let tableName = "Authors"
    static let fetchRelations = "*, Books(*)"

    internal init(name: String, birthyear: Int, books: [Book] = []) {
        self.name = name
        self.birthyear = birthyear
        self.books = books
    }

    var id: Int?
    var createdAt: Date = .now
    var name: String
    var birthyear: Int
    
    // Relations
    
    var books: [Book]
    
    
    
    
    // MARK: - Custom Encoding and Decoding
    
    enum DecodingKeys: String, CodingKey {
        case id, name, birthyear
        case createdAt = "created_at"
        case books = "Books"
    }
    enum EncodingKeys: String, CodingKey {
        case id, name, birthyear
        case createdAt = "created_at"
//        case books = "Books"
    }


    // Custom decoding initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        
        id =            try container.decode(Int.self, forKey: .id)
        createdAt =     try container.decode(Date.self, forKey: .createdAt)
        name =          try container.decode(String.self, forKey: .name)
        birthyear =     try container.decode(Int.self, forKey: .birthyear)
        
        books =         try container.decodeIfPresent([Book].self, forKey: .books) ?? []
    }
    
    // Custom encoding method
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(name, forKey: .name)
        try container.encode(birthyear, forKey: .birthyear)
    }
}





