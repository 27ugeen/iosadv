//
//  FeedViewModelTests.swift
//  NavigationTests
//
//  Created by GiN Eugene on 22/7/2022.
//

import Quick
import Nimble
@testable import Navigation

class FeedViewModelTests: QuickSpec {
    
    override func spec() {
        let feedVM = FeedViewModel()
        let testPass = "Password"
        
        //MARK: - check() testing
        describe("check() testing") {
            context("when pass is ok") {
                it("then expect true") {
                    let actual = feedVM.check(word: testPass)
                    
                    expect(actual).to(equal(true))
                }
            }
            
            context("when pass is NOT ok") {
                it("then expect true") {
                    let actual = feedVM.check(word: "123")
                    
                    expect(actual).to(equal(false))
                }
            }
        }
    }
}
