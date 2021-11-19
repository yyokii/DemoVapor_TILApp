//
//  CreateAcronymCategoryPivot.swift
//  
//
//  Created by Higashihara Yoki on 2021/11/16.
//

import Fluent

struct CreateAcronymCategoryPivot: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("acronym-category-pivot")
            .id()
            .field("acronymID", .uuid, .required, .references("acronyms", "id", onDelete: .cascade)) // .cascade: This causes the database to remove the relationship automatically instead of throwing an error.
            .field("categoryID", .uuid, .required, .references("categories", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("acronym-category-pivot").delete()
    }
}
