//
//  LoginViewModel.swift
//  Navigation
//
//  Created by GiN Eugene on 16/2/2022.
//

import Foundation
import UIKit

enum AuthorizationStrategy {
    case logIn
    case newUser
}

protocol LoginViewInputProtocol: AnyObject {
    func userTryAuthorize(withStrategy: AuthorizationStrategy)
}

protocol LoginViewOutputProtocol: AnyObject {
    func signInUser(userLogin: String, userPassword: String, completition: @escaping (String?) -> Void)
    func createUser(userLogin: String, userPassword: String, completition: @escaping (String?) -> Void)
}

final class LoginViewModel: LoginViewOutputProtocol {
    //MARK: - Localization
    
    let emailExists = "email_exists".localized()
    let incorrectEmailFormat = "incorrect_email_format".localized()
    let shortPassword = "short_password".localized()
    let incorrectLoginPassword = "incorrect_login_password".localized()
    //MARK: - Props
    
    let dataProvider: DataProvider = RealmDataProvider()
    weak var view: LoginViewInputProtocol?
    //MARK: - Methods
    
    func getCurrentUser(_ userId: String) -> User {
        return dataProvider.getUsers().first(where: { $0.id == userId }) ?? User(email: "nil", password: "nil")
    }
    
    func createUser(userLogin: String, userPassword: String, completition: @escaping (String?) -> Void) {
        let users = dataProvider.getUsers()
        
        for user in users {
            if user.email == userLogin {
                completition(emailExists)
                return
            }
        }
        if !userLogin.isValidEmail {
            completition(incorrectEmailFormat)
            return
        }
        if userPassword.count < 6 {
            completition(shortPassword)
            return
        }
        
        let newUser = User(email: userLogin, password: userPassword)
        dataProvider.createUser(newUser)
        UserDefaults.standard.set(newUser.id, forKey: "userId")
        UserDefaults.standard.set(true, forKey: "isSignedUp")
    }
    
    func signInUser(userLogin: String, userPassword: String, completition: @escaping (String?) -> Void) {
        let users = dataProvider.getUsers()
        
        if users.contains(where: { user in
            user.email == userLogin && user.password.hash == userPassword.hash
        }) {
            for user in users {
                UserDefaults.standard.set(user.id, forKey: "userId")
                UserDefaults.standard.set(true, forKey: "isSignedUp")
            }
            print("Sign in result: \(userLogin)")
        } else {
            completition(incorrectLoginPassword)
        }
    }
}
