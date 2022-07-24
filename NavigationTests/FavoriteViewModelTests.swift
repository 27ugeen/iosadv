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
        let testAuthor = "testAuthor"
        let testFavPostStub = FavoritePostStub(title: "tetTitle", author: testAuthor, image: imageMock, description: "testDescript", likes: 0, views: 0)
        var testArrPostStubs = [testFavPostStub]
        var testArrFilteredPostSubs = [testFavPostStub]
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
                                                       author: testAuthor,
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
        
        describe("removePostFromFavorite() testing") {
            context("when func started") {
                beforeEach {
                    favVM.favoritePosts.append(testFavPostStub)
                }
                it("then expect remove post at index") {
                    let startCount = favVM.favoritePosts.count
                    favVM.removePostFromFavorite(post: testFavPostStub, index: favVM.favoritePosts.endIndex - 1)
                    
                    expect(favVM.favoritePosts.count).to(equal(startCount - 1))
                }
            }
        }
        
        describe("getFilteredPosts() testing") {
            beforeEach {
                testArrFilteredPostSubs = []
                testArrFilteredPostSubs.append(testFavPostStub)
                favVM.getAllFavoritePosts()
                favVM.favoritePosts.append(testFavPostStub)
            }
            context("when author found && filteredArr > 0") {
                it("then expect receive filtered post && favArr == filteredArr") {
                    favVM.filteredPosts.append(testFavPostStub)
                    favVM.favoritePosts = favVM.filteredPosts
                    
                    expect(favVM.filteredPosts.count).to(equal(testArrFilteredPostSubs.count))
                    expect(favVM.favoritePosts.count).toNot(equal(0))
                    expect(favVM.favoritePosts.count).to(equal(favVM.filteredPosts.count))
                }
            }
            
            context("when author found && filteredArr > 0") {
                it("then expect favArr == filteredArr") {
                    favVM.favoritePosts = favVM.filteredPosts
                    
                    expect(favVM.favoritePosts.count).to(equal(favVM.filteredPosts.count))
                }
            }
            
            context("when authir didn't find && filteredArr == 0") {
                it("then expect favArr == 0, filteredArr == 0") {
                    favVM.getFilteredPosts(postAuthor: "nil")
                    
                    expect(favVM.filteredPosts.count).to(equal(0))
                    expect(favVM.filteredPosts.count).to(equal(0))
                }
            }
        }
        
    }
}
