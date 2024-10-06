//
//  Book.swift
//  SupabaseDemo
//
//  Created by Christoph Rohrer on 29.09.24.
//

import Foundation
import MyMacro

@SynthCodable
struct Country: Model {
    
    
    static let tableName = "Country"
    static let relations: [String] = ["Author"]

    internal init(name: String) {
        self.name = name
    }

    var id: Int?
    var createdAt: Date = .now
    var name: String
    
    // Relations
    
    @Relation var authors: [Author] = []
    
    
    /*
    // MARK: - Custom Encoding and Decoding
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case createdAt = "created_at"
        case authors = "Authors"
    }


    // Custom decoding initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id =            try container.decode(Int.self, forKey: .id)
        createdAt =     try container.decode(Date.self, forKey: .createdAt)
        name =          try container.decode(String.self, forKey: .name)
        
        authors =       try container.decodeIfPresent([Author].self, forKey: .authors) ?? []
    }
    
    // Custom encoding method
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(name, forKey: .name)
    }
     */
}





