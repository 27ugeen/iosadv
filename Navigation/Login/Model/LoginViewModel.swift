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
    //MARK: - props
    private let dataProvider: DataProvider
    private let userValidator: LoginPassValidator
    var isValid: Bool = false
    
    //MARK: - localization
    let incorrectLoginPassword = "incorrect_login_password".localized()
    
    //MARK: - init
    init(provider: DataProvider, validator: LoginPassValidator) {
        dataProvider = provider
        userValidator = validator
    }
    //MARK: - methods
    func getCurrentUser(_ userId: String) -> User {
        return dataProvider.getUserById(id: userId) ?? User(email: "", password: "")
    }
    
    func createUser(userLogin: String, userPassword: String, completition: @escaping (String?) -> Void) {
        let newUser = User(email: userLogin, password: userPassword)
        
        isValid = userValidator.validate(newUser) { error in
            if let unwrError = error {
                if unwrError != "" {
                    completition(error)
                    return
                }
            }
        }
        
        if isValid {
            dataProvider.createUser(newUser)
            UserDefaults.standard.set(newUser.id, forKey: "userId")
            UserDefaults.standard.set(true, forKey: "isSignedUp")
        }
    }
    
    func signInUser(userLogin: String, userPassword: String, completition: @escaping (String?) -> Void) {
        let currentUser = dataProvider.getUserByLogin(login: userLogin)
        
        if currentUser == nil {
            completition(incorrectLoginPassword)
            return
        }
        
        if let unwrUser = currentUser {
            if unwrUser.email != userLogin || unwrUser.password.hash != userPassword.hash {
                completition(incorrectLoginPassword)
                return
            }
        }
        UserDefaults.standard.set(currentUser?.id, forKey: "userId")
        UserDefaults.standard.set(true, forKey: "isSignedUp")
        
        print("Sign in result: \(userLogin)")
    }
}
