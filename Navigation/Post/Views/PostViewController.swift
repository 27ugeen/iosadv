//
//  PostViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class PostViewController: UIViewController {
    //MARK: - props
    var goToInfoAction: (() -> Void)?
    
    //MARK: - init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    //MARK: - methods
    private func setupViews() {
        self.title = "Black Cat"
        self.view.backgroundColor = Palette.postBackgrdColor
        
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"), style: UIBarButtonItem.Style.done, target: self, action: #selector(postTapped))
        
        self.navigationItem.setRightBarButtonItems([button], animated: true)
    }
    
    @objc private func postTapped() {
        self.goToInfoAction?()
    }
    
}
