//
//  CategoriesController.swift
//  
//
//  Created by Higashihara Yoki on 2021/11/16.
//

import Vapor

struct CategoriesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        
        let categoriesRoute = routes.grouped("api", "categories")
        
        // get
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.get(":categoryID", use: getHandler)
        
        // post
        categoriesRoute.post(use: createHandler)
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<Category> {
        let category = try req.content.decode(Category.self)
        return category.save(on: req.db).map { category }
    }
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<[Category]> {
        Category.query(on: req.db).all()
    }
    
    func getHandler(_ req: Request) -> EventLoopFuture<Category> {
        Category.find(req.parameters.get("categoryID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
}

