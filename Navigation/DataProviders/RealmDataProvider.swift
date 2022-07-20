//
//  RealmDataProvider.swift
//  Navigation
//
//  Created by GiN Eugene on 27/3/2022.
//

import Foundation
import RealmSwift

@objcMembers class CachedUser: Object {
    dynamic var id: String?
    dynamic var email: String?
    dynamic var password: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class RealmDataProvider: DataProvider {
    //MARK: - props
    
    weak var delegate: DataProviderDelegate?
    private var notificationToken: NotificationToken?
    
    private var realm: Realm? {
        var config = Realm.Configuration()
        //Path to container after reload app:
        //print(Realm.Configuration.defaultConfiguration.fileURL?.path)
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("users.realm")
        return try? Realm(configuration: config)
    }
    //MARK: - init
    
    init() {
        notificationToken = realm?.observe { [unowned self] _, _ in
            self.delegate?.usersDidChange(dataProivider: self)
        }
    }
    //MARK: - methods
    
    func getUserByLogin(login: String) -> User? {
        let usersDb = realm?.objects(CachedUser.self)
        
        let existedUsers = usersDb?.where {
            ($0.email == login)
        }
        
        if existedUsers?.count == 1 {
            if let currentUser = existedUsers?.first {
                return User(id: currentUser.id ?? "", email: login, password: currentUser.password ?? "")
            }
        }
        return nil
    }
    
    func getUserById(id: String) -> User? {
        guard let cachedUser = realm?.object(ofType: CachedUser.self, forPrimaryKey: id) else { return nil }
        return User(email: cachedUser.email ?? "", password: cachedUser.password ?? "")
    }
    
    func createUser(_ user: User) {
        let cachedUser = CachedUser()
        cachedUser.id = user.id
        cachedUser.email = user.email
        cachedUser.password = user.password
        
        try? realm?.write {
            realm?.add(cachedUser)
        }
    }
    
    func updateUser(_ user: User) {
        guard let cachedUser = realm?.object(ofType: CachedUser.self, forPrimaryKey: user.id) else { return }
        
        try? realm?.write {
            cachedUser.email = user.email
            cachedUser.password = user.password
        }
    }
    
    func deleteUser(_ user: User) {
        guard let cachedUser = realm?.object(ofType: CachedUser.self, forPrimaryKey: user.id) else { return }
        
        try? realm?.write {
            realm?.delete(cachedUser)
        }
    }
}
