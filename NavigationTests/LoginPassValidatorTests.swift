//
//  LoginPassValidatorTests.swift
//  NavigationTests
//
//  Created by GiN Eugene on 2/6/2022.
//

import Quick
import Nimble
@testable import Navigation

class LoginPassValidatorTests: QuickSpec {
    
    private var dataProvider: DataProviderMock!
    private var validator: LoginPassValidator!
    
    override func spec() {
        self.dataProvider = DataProviderMock()
        self.validator = LoginPassValidator(provider: self.dataProvider)
        
    //MARK: - validate() testing
        describe("validate() testing") {
            context("when email is not valid") {
                it("then expect error & return false") {
                   let isValidate = self.validator.validate(User(email: "", password: "123456")) { error in
                        expect(error).to(equal(self.validator.incorrectEmailFormat))
                    }
                    expect(isValidate).to(equal(false))
                }
            }
            
            context("when password too short") {
                it("then expect error & return false") {
                    let isValidate = self.validator.validate(User(email: "test@gmail.com", password: "")) { error in
                        expect(error).to(equal(self.validator.shortPassword))
                     }
                     expect(isValidate).to(equal(false))
                }
            }
            
            context("when password too long") {
                it("then expect error & return false") {
                    let isValidate = self.validator.validate(User(email: "test@gmail.com", password: String(repeating: "1", count: 101))) { error in
                        expect(error).to(equal(self.validator.longPassword))
                     }
                     expect(isValidate).to(equal(false))
                }
            }
            
            context("when email duplicate") {
                beforeEach {
                    self.dataProvider.shouldGetUserResponse = nil
                }
                it("then expect error & return false") {
                    self.dataProvider.shouldGetUserResponse = User(email: "test@gmail.com", password: "123456")
                    
                    let isValidate = self.validator.validate(User(email: "test@gmail.com", password: "123456")) { error in
                        expect(error).to(equal(self.validator.emailExists))
                     }
                     expect(isValidate).to(equal(false))
                }
            }
            
            context("when user is OK") {
                beforeEach {
                    self.dataProvider.shouldGetUserResponse = nil
                }
                it("then NOT expect error & return true") {
                    let isValidate = self.validator.validate(User(email: "test@gmail.com", password: "123456")) { error in
                        expect(error).to(equal(""))
                     }
                     expect(isValidate).to(equal(true))
                }
            }
        }
    }
}
