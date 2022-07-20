//
//  FeedViewModel.swift
//  Navigation
//
//  Created by GiN Eugene on 7/1/22.
//

import Foundation

protocol ViewOutput {
    func check(word: String) -> Bool
}

final class FeedViewModel: ViewOutput {
    //MARK: - props
    private let password = "Password"
    
    //MARK: - methods
    func check(word: String) -> Bool {
       return word == password ? true : false
    }
}
