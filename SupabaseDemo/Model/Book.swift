//
//  Book.swift
//  SupabaseDemo
//
//  Created by Christoph Rohrer on 29.09.24.
//

import Foundation
import MyMacro


@SynthCodable
struct Book: Model {
    
    static let tableName = "Book"
    static let relations = ["Author"]

    
    internal init(title: String, pages: Int, authorId: Int? = nil, author: Author? = nil) {
//        self.id = id
//        self.createdAt = createdAt
        self.title = title
        self.pages = pages
        self.authorId = authorId
        self.author = author
    }
    
    var id: Int?
    var createdAt: Date = .now
    var title: String
    var pages: Int
    
    // Foreign Keys
    
    @ForeignKey var authorId: Int?
    
    // Relations
    
    @Relation var author: Author?
    
    
    
    
    /*
    // MARK: - Custom Encoding and Decoding

    enum DecodingKeys: String, CodingKey {
        case id, title, pages
        case createdAt = "created_at"
        case authorId = "author_id"
        case author = "Authors"
   }
    enum EncodingKeys: String, CodingKey {
        case id, title, pages
        case createdAt = "created_at"
        case authorId = "author_id"
//        case author = "Authors"
   }

    // Custom decoding initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        
        id =            try container.decode(Int.self, forKey: .id)
        createdAt =     try container.decode(Date.self, forKey: .createdAt)
        title =         try container.decode(String.self, forKey: .title)
        pages =         try container.decode(Int.self, forKey: .pages)
        authorId =      try container.decodeIfPresent(Int.self, forKey: .authorId)

        author =        try container.decodeIfPresent(Author.self, forKey: .author)
    }
    
    // Custom encoding method
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EncodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(title, forKey: .title)
        try container.encode(pages, forKey: .pages)
        try container.encode(authorId, forKey: .authorId)
    }
     */
}







