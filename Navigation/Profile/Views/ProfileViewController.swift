//
//  ProfileViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit
import UniformTypeIdentifiers

class ProfileViewController: UIViewController {
    //MARK: - props
    let profileViewModel: ProfileViewModel
    var goToPhotoGalleryAction: (() -> Void)?
    var logOutAction: (() -> Void)?
    
    let cellID = String(describing: PostTableViewCell.self)
    let photoCellID = String(describing: PhotosTableViewCell.self)
    let headerID = String(describing: ProfileHeaderView.self)
    
    //MARK: - subviews
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    //MARK: - init
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Palette.appTintColor
        self.navigationController?.isNavigationBarHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapEdit(_:)))
        tapGesture.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(tapGesture)
        
        setupTableView()
        setupConstraints()
    }
    
    //MARK: - methods
    @objc func tapEdit(_ recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.tableView.cellForRow(at: tapIndexPath) as? PostTableViewCell {
                    if tapIndexPath.row == 0 {
                        return
                    } else {
                        tappedCell.post = PostsStorage.tableModel[tapIndexPath.section].posts[tapIndexPath.row - 1]
                        profileViewModel.addToFavoritePosts(tappedCell.post!) { message in
                            self.showAlert(message: message ?? "")
                        }
                    }
                }
            }
        }
    }
}
//MARK: - setupTableView
extension ProfileViewController {
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Palette.appTintColor
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: photoCellID)
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: headerID)
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}
//MARK: - setupConstraints
extension ProfileViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
//MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return PostsStorage.tableModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostsStorage.tableModel[section].posts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: PhotosTableViewCell = tableView.dequeueReusableCell(withIdentifier: photoCellID, for: indexPath) as! PhotosTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! PostTableViewCell
            cell.post = PostsStorage.tableModel[indexPath.section].posts[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return PostsStorage.tableModel[section].title
    }
}
//MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.goToPhotoGalleryAction?()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ProfileHeaderView()
        headerView.logOutAction = {
            self.logOutAction?()
        }
        return headerView
    }
}
//MARK: - UITableViewDragDelegate
extension ProfileViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard indexPath.row != 0 else { return [] }
        
        let post = PostsStorage.tableModel[indexPath.section].posts[indexPath.row - 1]
        
        let imgProvider = NSItemProvider(object: post.image as UIImage)
        let descriptProvider = NSItemProvider(object: post.descript as NSString)
        
        let imgDragItem = UIDragItem(itemProvider: imgProvider)
        let descriptDragItem = UIDragItem(itemProvider: descriptProvider)
        
        imgDragItem.localObject = post.image
        descriptDragItem.localObject = post.descript
        
        return [imgDragItem, descriptDragItem]
    }
}

//MARK: - UITableViewDropDelegate
extension ProfileViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: UIImage.self)
        session.canLoadObjects(ofClass: NSString.self)
        return true
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if tableView.hasActiveDrag {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        let initIndexPath: IndexPath
        
        var postDescript: String = "nil"
        var postImage: UIImage = UIImage()
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Receive last IndexPath
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        let tapLocation = UITapGestureRecognizer().location(in: tableView)
        if let tapIndexPath = tableView.indexPathForRow(at: tapLocation) {
            initIndexPath = tapIndexPath
        } else {
            initIndexPath = destinationIndexPath
        }
        
        guard destinationIndexPath.row > 0 else {
            showAlert(message: "You can't insert here!")
            print("Negative array index")
            return
        }
        
        let group = DispatchGroup()
        
        group.enter()
        coordinator.session.loadObjects(ofClass: NSString.self) { objects in
            let uStrings = objects as! [String]
            for uString in uStrings {
                postDescript = uString
                break
            }
            group.leave()
        }
        
        group.enter()
        coordinator.session.loadObjects(ofClass: UIImage.self) { objects in
            let uImages = objects as! [UIImage]
            for uImage in uImages {
                postImage = uImage
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            let newPost = Post(title: "Title", author: "Drag&Drop", image: postImage, descript: postDescript, likes: 0, views: 0)
            PostsStorage.tableModel[destinationIndexPath.section].posts.insert(newPost, at: destinationIndexPath.row - 1)
            tableView.reloadData()
            
            if coordinator.proposal.operation == .move {
                PostsStorage.tableModel[initIndexPath.section].posts.remove(at: initIndexPath.row)
                tableView.reloadData()
            }
        }
    }
}
