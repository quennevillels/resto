//
//  UserController.swift
//  App
//
//  Created by Bob Quenneville on 2019-01-09.
//

import Vapor

final class UserController {

    func index(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }

    func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
    }

    func createUsers(_ req: Request) throws -> Future<[User]> {
        return try req.content.decode([User].self).flatMap { users in
            return users.compactMap { user in user.save(on: req) }.flatten(on: req)
        }
    }

    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(User.self).flatMap { user in
            return user.delete(on: req)
            }.transform(to: .ok)
    }

    func routes(_ router: Router) {

        router.get("user", use: self.index)
        router.post("user", use: self.create)
        router.post("users", use: self.createUsers)
        router.delete("user", User.parameter, use: self.delete)
    }
}
