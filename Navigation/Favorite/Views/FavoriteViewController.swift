//
//  FavoriteViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 30/3/2022.
//

import UIKit

class FavoriteViewController: UIViewController {
    //MARK: - Props
    let favoriteViewModel: FavoriteViewModel
    
    var goToSearchAction: (() -> Void)?
    
    let favoritePostCellID = String(describing: FavoritePostTableViewCell.self)
    let favoriteSearchHeaderID = String(describing: FavoriteSearchHeaderView.self)
    let tableView = UITableView(frame: .zero, style: .plain)
    
    //MARK: - Localization
    let postAuthor = "post_author".localized()
    let postViews = "post_views".localized()
    let filteredPosts = "filtered_posts".localized()
    let notFilteredPosts = "not_filtered_posts".localized()
    let favoriteVCTitle = "bar_favorite".localized()
    let postDeleteAction = "post_delete_action".localized()
    let findPostAlert = "find_post_alert".localized()
    
    //MARK: - Subviews
//    lazy var searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searcAction))
    
    lazy var resetBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearFilter))
    
    //MARK: - init
    init(favoriteViewModel: FavoriteViewModel) {
        self.favoriteViewModel = favoriteViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Palette.appTintColor
        
        UserDefaults.standard.set("", forKey: "author")
        let searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searcAction))
        
        self.navigationItem.setRightBarButtonItems([searchBarButton, resetBarButton], animated: true)
        
        setupTableView()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let author = UserDefaults.standard.string(forKey: "author")
        
        if let unwrappedAuthor = author {
            guard unwrappedAuthor == "" else {
                self.getFilteredPosts(filteredAuthor: unwrappedAuthor)
                return
            }
            favoriteViewModel.getAllFavoritePosts()
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if favoriteViewModel.favoritePosts.isEmpty {
            self.showAlert(message: findPostAlert)
        }
    }
    
    //MARK: - methods
    func getFilteredPosts(filteredAuthor: String) {
        UserDefaults.standard.set(filteredAuthor, forKey: "author")
        favoriteViewModel.getFilteredPosts(postAuthor: filteredAuthor)
        tableView.reloadData()
    }
    
    @objc func searcAction() {
        self.goToSearchAction?()
    }
    
    @objc func clearFilter() {
        UserDefaults.standard.set("", forKey: "author")
        favoriteViewModel.getAllFavoritePosts()
        tableView.reloadData()
    }
}
// MARK: - setup table view
extension FavoriteViewController {
    func setupTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Palette.appTintColor
        tableView.register(FavoritePostTableViewCell.self, forCellReuseIdentifier: favoritePostCellID)
        tableView.register(FavoriteSearchHeaderView.self, forHeaderFooterViewReuseIdentifier: favoriteSearchHeaderID)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}
// MARK: - setup views
extension FavoriteViewController {
    func setupViews() {
        self.title = favoriteVCTitle
        
        let constraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteViewModel.favoritePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: favoritePostCellID, for: indexPath) as! FavoritePostTableViewCell
        let postLikes = String.localizedStringWithFormat("post_likes".localized(), favoriteViewModel.favoritePosts[indexPath.row].likes)
        
        cell.postAuthorLabel.text = "\(postAuthor): \(favoriteViewModel.favoritePosts[indexPath.row].author)"
        cell.postTitleLabel.text = favoriteViewModel.favoritePosts[indexPath.row].title
        cell.postImageView.image = favoriteViewModel.favoritePosts[indexPath.row].image
        cell.postDescriptionLabel.text = favoriteViewModel.favoritePosts[indexPath.row].description
        cell.postlikesLabel.text = postLikes
        cell.postViewsLabel.text = "\(postViews): \(favoriteViewModel.favoritePosts[indexPath.row].views)"
        return cell
        
    }
}
// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: favoriteSearchHeaderID) as! FavoriteSearchHeaderView
        let author = UserDefaults.standard.string(forKey: "author")
        if author != "" {
            if let unwrappedAuthor = author {
                headerView.searchLabel.text = "\(filteredPosts) \"\(unwrappedAuthor)\""
            }
        } else {
            headerView.searchLabel.text = notFilteredPosts
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let post = favoriteViewModel.favoritePosts[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: postDeleteAction) { _, _, complete in
            self.favoriteViewModel.removePostFromFavorite(post: post, index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
