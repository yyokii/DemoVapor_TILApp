//
//  Category.swift
//  
//
//  Created by Higashihara Yoki on 2021/11/16.
//

import Fluent
import Vapor

final class Category: Model, Content {
    static let schema = "categories"
    
    @ID
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Siblings( through: AcronymCategoryPivot.self,
               from: \.$category,
               to: \.$acronym)
    var acronyms: [Acronym]
    
    init() {}
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

