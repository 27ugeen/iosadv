//
//  LoginViewModelTests.swift
//  NavigationTests
//
//  Created by GiN Eugene on 23/5/2022.
//

import Quick
import Nimble
@testable import Navigation

class LoginViewModelTests: QuickSpec {
    
    override func spec() {
        let realmMock = DataProviderMock()
        let validator = LoginPassValidator(provider: realmMock)
        let viewModel = LoginViewModel(provider: realmMock, validator: validator)
        let testUser = User(id: "testId", email: "test@gmail.com", password: "123456")
        let nilTestUser = User(id: "nil", email: "nil", password: "nil")
        
        //MARK: - getCurrentUser() testing
        describe("getCurrentUser() testing") {
            context("when user is ok") {
                beforeEach {
                    realmMock.shouldGetUserResponse = testUser
                }
                it("then expext current user") {
                    let actualUser = viewModel.getCurrentUser(testUser.id)
                    expect(actualUser.email).to(equal("test@gmail.com"))
                    expect(actualUser.password).to(equal("123456"))
                    expect(actualUser).to(equal(testUser))
                }
            }
            
            context("when user is NOT exists") {
                beforeEach {
                    realmMock.shouldGetUserResponse = nil
                }
                it("then expect empty user") {
                    let actualUser = viewModel.getCurrentUser("")
                    expect(actualUser.email).to(equal(""))
                    expect(actualUser.password).to(equal(""))
                }
            }
        }
        
        //MARK: - createUser() testing
        describe("createUser() testing") {
            context("when user is NOT valid") {
                beforeEach {
                    viewModel.isValid = false
                }
                it("then expect error messege") {
                    viewModel.createUser(userLogin: "", userPassword: "") { error in
                        expect(error).notTo(equal(""))
                    }
                    expect(viewModel.isValid).to(equal(false))
                }
            }
            
            context("when user valid with undefined") {
                beforeEach {
                    viewModel.isValid = false
                }
                it("then NOT expect error messege") {
                    viewModel.createUser(userLogin: "test@gmail.com", userPassword: "123456") {
                        error in
                        expect(error).to(equal(""))
                    }
                    expect(viewModel.isValid).to(equal(true))
                }
            }
            
            context("when user valid with nil") {
                beforeEach {
                    viewModel.isValid = false
                    realmMock.shouldGetUserResponse = nil
                }
                it("then NOT expect error messege") {
                    viewModel.createUser(userLogin: "test@mail.com", userPassword: "123456") {
                        error in
                        expect(error).to(equal(""))
                    }
                    expect(viewModel.isValid).to(equal(true))
                }
            }
            
            context("when should create user normally") {
                beforeEach {
                    realmMock.shouldGetUserResponse = nil
                }
                it("then expect creating new User, NOT expect error message") {
                    let newUser = testUser
                    viewModel.createUser(userLogin: "test@gmail.com", userPassword: "123456") { error in
                        expect(error).to(equal(""))
                    }
                    expect(newUser.email).to(equal("test@gmail.com"))
                    expect(newUser.password).to(equal("123456"))
                }
            }
        }
        
        //MARK: - signInUser() testing
        describe("signInUser() testing") {
            context("when User is nil") {
                beforeEach {
                    realmMock.shouldGetUserResponse = nil
                }
                it("then expect error message") {
                    viewModel.signInUser(userLogin: "", userPassword: "") { error in
                        expect(error).to(equal(viewModel.incorrectLoginPassword))
                    }
                }
            }
            
            context("when login is NOT ok") {
                beforeEach {
                    realmMock.shouldGetUserResponse = nilTestUser
                }
                it("then expect error message") {
                    viewModel.signInUser(userLogin: "nil", userPassword: "123456") { error in
                        expect(error).to(equal(viewModel.incorrectLoginPassword))
                    }
                    expect(nilTestUser.email).notTo(equal(testUser.email))
                }
            }
            
            context("when password is NOT ok") {
                beforeEach {
                    realmMock.shouldGetUserResponse = nilTestUser
                }
                it("then expect error message") {
                    viewModel.signInUser(userLogin: "test@gmail.com", userPassword: "nil") { error in
                        expect(error).to(equal(viewModel.incorrectLoginPassword))
                    }
                    expect(nilTestUser.password).notTo(equal(testUser.password))
                }
            }
            
            context("when should sign in user normally") {
                beforeEach {
                    realmMock.shouldGetUserResponse = testUser
                }
                it("then expect sign in User, NOT expect error message") {
                    viewModel.signInUser(userLogin: "test@gmail.com", userPassword: "123456") { error in
                        expect(error).to(equal(""))
                    }
                    expect(testUser.email).to(equal("test@gmail.com"))
                    expect(testUser.password).to((equal("123456")))
                }
            }
        }
        
        DispatchQueue.main.async {
            UserDefaults.standard.set(false, forKey: "isSignedUp")
        }
    }
    
}

class DataProviderMock: DataProvider {
    
    weak var delegate: DataProviderDelegate?
    var shouldGetUserResponse: User?
    
    func getUserById(id: String) -> User? {
        return shouldGetUserResponse ?? nil
    }
    
    func getUserByLogin(login: String) -> User? {
        return shouldGetUserResponse ?? nil
    }
    
    func createUser(_ user: User) {}
    func updateUser(_ user: User) {}
    func deleteUser(_ user: User) {}
}
