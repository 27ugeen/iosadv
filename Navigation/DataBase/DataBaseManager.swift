//
//  DataBaseManager.swift
//  Navigation
//
//  Created by GiN Eugene on 31/3/2022.
//

import Foundation
import CoreData

class DataBaseManager {
    
    static let shared = DataBaseManager()
    //==================Container========================
    private let persistentContainer: NSPersistentContainer
    private lazy var backgroundContext = persistentContainer.newBackgroundContext()

    init() {
    let container = NSPersistentContainer(name: "DataBaseModel")
    container.loadPersistentStores { description, error in
       if let error = error {
           fatalError("Unable to load persistent stores: \(error)")
       }
    }
        self.persistentContainer = container
    }
    
    func getAllPosts() -> [FavoritePost?] {
        let fetchRequest = FavoritePost.fetchRequest()
        var favoritePostsArray: [FavoritePost]?
            do {
                favoritePostsArray = try persistentContainer.viewContext.fetch(fetchRequest)
            } catch let error {
                print(error)
            }
        return favoritePostsArray ?? []
    }
    
    func addPost(_ post: Post, completition: @escaping (String?) -> Void) {
        
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            let fetchRequest = FavoritePost.fetchRequest()
            
            do {
                let settings = try self.backgroundContext.fetch(fetchRequest)
                
                if settings.contains(where:  { $0.title == post.title }) {
                    completition("This post has already been added!")
                    print("This post has already been added!")
                } else {
                    if let newSet = NSEntityDescription.insertNewObject(forEntityName: "FavoritePost", into: self.backgroundContext) as? FavoritePost {
                        newSet.title = post.title
                        newSet.author = post.author
                        newSet.image = post.image.jpegData(compressionQuality: .zero)
                        newSet.postDescription = post.description
                        newSet.likes = Int64(post.likes)
                        newSet.views = Int64(post.views)
                        
                        try self.backgroundContext.save()
                        print("Post has been added!")
                    } else {
                        fatalError("Unable to insert FavoritePost entity")
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func deletePost(favPost: FavoritePostStub) {
        let fetchRequest = FavoritePost.fetchRequest()
        
        do {
            let posts = try persistentContainer.viewContext.fetch(fetchRequest)
            
            posts.forEach {
                if ($0.title == favPost.title) {
                    persistentContainer.viewContext.delete($0)
                    print("Post \"\($0.title ?? "")\" has been removed from favorites")
                }
            }
            try persistentContainer.viewContext.save()
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
