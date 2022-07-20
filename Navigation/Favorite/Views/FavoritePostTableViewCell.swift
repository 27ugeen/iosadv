//
//  FavoritePostTableViewCell.swift
//  Navigation
//
//  Created by GiN Eugene on 1/4/2022.
//

import UIKit

class FavoritePostTableViewCell: UITableViewCell {
    //MARK: - subviews
    let postAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    let postTitleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = Palette.mainTextColor
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.numberOfLines = 3
        return title
    }()
    
    let postImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .black
        return image
    }()
    
    let postDescriptionLabel: UILabel = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        description.textColor = .systemGray
        description.numberOfLines = 0
        return description
    }()
    
    let postlikesLabel: UILabel = {
        let likes = UILabel()
        likes.translatesAutoresizingMaskIntoConstraints = false
        likes.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        likes.textColor = Palette.mainTextColor
        return likes
    }()
    
    let postViewsLabel: UILabel = {
        let views = UILabel()
        views.translatesAutoresizingMaskIntoConstraints = false
        views.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        views.textColor = Palette.mainTextColor
        return views
    }()
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Palette.appTintColor
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - setupViews
extension FavoritePostTableViewCell {
    private func setupViews() {
        contentView.addSubview(postAuthorLabel)
        contentView.addSubview(postTitleLabel)
        contentView.addSubview(postImageView)
        contentView.addSubview(postDescriptionLabel)
        contentView.addSubview(postlikesLabel)
        contentView.addSubview(postViewsLabel)
        
        NSLayoutConstraint.activate([
            postAuthorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            postAuthorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            postAuthorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            postTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 16),
            postTitleLabel.topAnchor.constraint(equalTo: postAuthorLabel.bottomAnchor, constant: 5),
            postTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.topAnchor.constraint(equalTo: postTitleLabel.bottomAnchor, constant: 12),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor),
            
            postDescriptionLabel.leadingAnchor.constraint(equalTo: postTitleLabel.leadingAnchor),
            postDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postDescriptionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            
            postlikesLabel.leadingAnchor.constraint(equalTo: postTitleLabel.leadingAnchor),
            postlikesLabel.topAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor, constant: 16),
            postlikesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            postViewsLabel.topAnchor.constraint(equalTo: postlikesLabel.topAnchor),
            postViewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            postViewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
