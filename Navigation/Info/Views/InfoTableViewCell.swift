//
//  InfoTableViewCell.swift
//  Navigation
//
//  Created by GiN Eugene on 12/2/2022.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    //MARK: - subviews
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.mainTextColor
        return label
    }()
    
    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - methods
    private func setupViews() {
        contentView.backgroundColor = Palette.infoBackgrdColor
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
        ])
    }
}
