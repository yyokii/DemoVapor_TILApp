//
//  Application+testable.swift
//  
//
//  Created by Higashihara Yoki on 2021/11/20.
//

import XCTVapor
import App

extension Application {
    static func testable() throws -> Application {
        let app = Application(.testing)
        try configure(app)
        // This adds commands to revert any migrations in the database and then run the migrations again. This provides you with a clean database for every test.
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
        
        return app
    }
}

