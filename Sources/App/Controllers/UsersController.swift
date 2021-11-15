//
//  UsersController.swift
//  
//
//  Created by Higashihara Yoki on 2021/11/14.
//

import Vapor

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let usersRoute = routes.grouped("api", "users")
        
        // get
        usersRoute.get(":userID", "acronyms", use: getAcronymsHandler)
        usersRoute.get(use: getAllHandler)
        usersRoute.get(":userID", use: getHandler)
        
        // post
        usersRoute.post(use: createHandler)
    }
    
    func createHandler(_ req: Request)
    throws -> EventLoopFuture<User> {
        
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }
    
    func getAcronymsHandler(_ req: Request)
    -> EventLoopFuture<[Acronym]> {
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { user in
                user.$acronyms.get(on: req.db)
            }
    }
    
    func getAllHandler(_ req: Request)
    -> EventLoopFuture<[User]> {
        User.query(on: req.db).all()
    }
    
    func getHandler(_ req: Request)
    -> EventLoopFuture<User> {
        User.find(req.parameters.get("userID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
}

