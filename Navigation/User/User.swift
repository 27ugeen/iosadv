//
//  User.swift
//  Navigation
//
//  Created by GiN Eugene on 27/3/2022.
//

import Foundation

final class User: Equatable {
    //MARK: - props
    let id: String
    let email: String
    let password: String
    
    //MARK: - init
    init(id: String = UUID().uuidString, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
    //MARK: - methods
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
        lhs.email == rhs.email &&
        lhs.password == rhs.password
    }
}
