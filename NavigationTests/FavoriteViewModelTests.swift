//
//  FavoriteViewModelTests.swift
//  NavigationTests
//
//  Created by GiN Eugene on 22/7/2022.
//

import Quick
import Nimble
@testable import Navigation

class FavoriteViewModelTests: QuickSpec {
    
    override func spec() {
        let favVM = FavoriteViewModel()
        let dbManager = DataBaseManagerMock.shared
        let imageMock = UIImage()
        let testFavPostStub = FavoritePostStub(title: "test", author: "test", image: imageMock, description: "test", likes: 0, views: 0)
        var testArrPostStubs = [testFavPostStub]
        let imageUrlMock = URL(string: "testImgUrl") ?? URL(fileURLWithPath: "")
        
        //MARK: - getAllFavoritePosts() testing
        describe("getAllFavoritePosts() testing") {
            context("when func started") {
                beforeEach {
                    testArrPostStubs = []
                }
                it("then expect get all fav posts from db") {
                    favVM.getAllFavoritePosts()
                    let testArrFavPosts = dbManager.getAllPosts()
                    
                    for _ in testArrFavPosts {
                        let newPostImage = dbManager.getImageFromDocuments(imageUrl: imageUrlMock)
                        let newPost = FavoritePostStub(title: "tetTitle",
                                                       author: "testAuthor",
                                                       image: newPostImage ?? imageMock,
                                                       description: "testDescript",
                                                       likes: 0,
                                                       views: 0)
                        testArrPostStubs.append(newPost)
                    }
                    expect(favVM.favoritePosts.count).to(equal(testArrFavPosts.count))
                    expect(favVM.favoritePosts.count).to(equal(testArrPostStubs.count))
                }
            }
        }
    }
}
