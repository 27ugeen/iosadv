//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by GiN Eugene on 1/4/2022.
//

import Foundation

protocol ProfileViewModelInputProtocol {
    func addToFavoritePosts(_ post: Post, completition: @escaping (String?) -> Void)
}

class ProfileViewModel: ProfileViewModelInputProtocol {
    
    func addToFavoritePosts(_ post: Post, completition: @escaping (String?) -> Void) {
        DataBaseManager.shared.addPost(post) { message in
            DispatchQueue.main.async {
                completition(message)
            }
        }
    }
}
