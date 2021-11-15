//
//  AcronymsController.swift
//  
//
//  Created by Higashihara Yoki on 2021/11/14.
//

import Vapor
import Fluent

struct CreateAcronymData: Content {
    let short: String
    let long: String
    let userID: UUID
}

struct AcronymsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let acronymsRoutes = routes.grouped("api", "acronyms")
        
        // delete
        acronymsRoutes.delete(":acronymID", use: deleteHandler)
        
        // get
        acronymsRoutes.get(use: getAllHandler)
        acronymsRoutes.get(":acronymID", use: getHandler)
        acronymsRoutes.get(":acronymID", "user", use: getUserHandler)
        acronymsRoutes.get("search", use: searchHandler)
        acronymsRoutes.get("first", use: getFirstHandler)
        acronymsRoutes.get("sorted", use: sortedHandler)
        
        // post
        acronymsRoutes.post(use: createHandler)
        
        // put
        acronymsRoutes.put(":acronymID", use: updateHandler)
    }
    
    func createHandler(_ req: Request) throws
    -> EventLoopFuture<Acronym> {
        let data = try req.content.decode(CreateAcronymData.self)
        
        let acronym = Acronym(short: data.short,
                              long: data.long,
                              userID: data.userID)
        return acronym.save(on: req.db).map { acronym }
    }
    
    func deleteHandler(_ req: Request)
    -> EventLoopFuture<HTTPStatus> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                acronym.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
    
    func getUserHandler(_ req: Request)
      -> EventLoopFuture<User> {
          
      Acronym.find(req.parameters.get("acronymID"), on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { acronym in
          acronym.$user.get(on: req.db)
        }
    }
    
    func getHandler(_ req: Request)
    -> EventLoopFuture<Acronym> {
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    func getFirstHandler(_ req: Request)
    -> EventLoopFuture<Acronym> {
        return Acronym.query(on: req.db)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    func getAllHandler(_ req: Request)
    -> EventLoopFuture<[Acronym]> {
        Acronym.query(on: req.db).all()
    }
    
    func updateHandler(_ req: Request) throws
    -> EventLoopFuture<Acronym> {
        let updateData =
        try req.content.decode(CreateAcronymData.self)
        return Acronym
            .find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                acronym.short = updateData.short
                acronym.long = updateData.long
                acronym.$user.id = updateData.userID
                return acronym.save(on: req.db).map {
                    acronym
                }
            }
    }
    
    func searchHandler(_ req: Request) throws
    -> EventLoopFuture<[Acronym]> {
        guard let searchTerm = req
                .query[String.self, at: "term"] else {
                    throw Abort(.badRequest)
                }
        return Acronym.query(on: req.db).group(.or) { or in
            or.filter(\.$short == searchTerm)
            or.filter(\.$long == searchTerm)
        }.all()
    }
    
    func sortedHandler(_ req: Request)
    -> EventLoopFuture<[Acronym]> {
        return Acronym.query(on: req.db)
            .sort(\.$short, .ascending).all()
    }
}

