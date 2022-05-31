//
//  UserValidation.swift
//  Navigation
//
//  Created by GiN Eugene on 30/5/2022.
//

import Foundation

protocol UserValidatorProtocol: AnyObject {
    func validate(_ user: User, _ completition: @escaping (String?) -> Void) -> Bool
}

final class LoginPassValidator: UserValidatorProtocol {
    //MARK: - Props
    
    private let dataProvider: DataProvider
    //MARK: - init
    
    init(provider: DataProvider) {
        dataProvider = provider
    }
    //MARK: - Localization
    
    let incorrectEmailFormat = "incorrect_email_format".localized()
    let shortPassword = "short_password".localized()
    let longPassword = "long_password".localized()
    let emailExists = "email_exists".localized()
    //MARK: - methods
    
    func validate(_ user: User, _ completition: @escaping (String?) -> Void) -> Bool {
        if !user.email.isValidEmail {
            completition(incorrectEmailFormat)
            return false
        }
        
        if user.password.count < 6 {
            completition(shortPassword)
            return false
        }
        
        if user.password.count > 100 {
            completition(longPassword)
            return false
        }
        
        let currentUser = self.dataProvider.getUserByLogin(login: user.email)
        
        
        if let unwrUser = currentUser {
            if unwrUser.email == user.email {
                completition(self.emailExists)
                return false
            }
        }
        
        return true
    }
}



