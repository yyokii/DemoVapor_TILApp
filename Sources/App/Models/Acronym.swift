//
//  Acronym.swift
//  
//
//  Created by Higashihara Yoki on 2021/11/14.
//

import Vapor
import Fluent

final class Acronym: Model {
    static let schema = "acronyms"
    
    @ID
    var id: UUID?
    
    @Field(key: "short")
    var short: String
    
    @Field(key: "long")
    var long: String
    
    @Parent(key: "userID")
    var user: User
    
    init() {}
    
    init(
        id: UUID? = nil,
        short: String,
        long: String,
        userID: User.IDValue
    ) {
        self.id = id
        self.short = short
        self.long = long
        self.$user.id = userID
    }
    
}

extension Acronym: Content {}