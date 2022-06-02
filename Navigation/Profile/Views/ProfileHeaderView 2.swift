//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by GiN Eugene on 25.07.2021.
//

import UIKit
import SnapKit

class ProfileHeaderView: UITableViewHeaderFooterView {
//MARK: - Props
    var logOutAction: (() -> Void)?
    
//MARK: - Localization
    let logOutUser = "logout_user".localized()
    let statusText = "status_text".localized()
    let statusTextEmpty = "status_text_empty".localized()
    let statusPlaceholderText = "status_placeholder_text".localized()
    let statusButton = "status_buton".localized()

//MARK: - SubViews
    let avatarImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.white.cgColor
        image.image = UIImage(named: "blackCat")
        image.layer.cornerRadius = 110 / 2
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let fullNameLabel: UILabel = {
        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "Hipster Cat"
        name.textColor = Palette.mainTextColor
        name.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return name
    }()
    
    lazy var logOutButton = MagicButton(title: logOutUser, titleColor: Palette.btnWithoutBorderLableColor) {
        self.logOutAction?()
    }
    
    lazy var statusLabel: UILabel = {
        let status = UILabel()
        status.translatesAutoresizingMaskIntoConstraints = false
        status.text = statusText
        status.textColor = .gray
        status.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return status
    }()
    
    lazy var statusTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        text.backgroundColor = .systemGray6
        text.layer.cornerRadius = 8
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.placeholder = statusPlaceholderText
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        return text
    }()
    
    lazy var setStatusButton = MagicButton(title: statusButton, titleColor: Palette.btnWithBorderLableColor) { [self] in
            (statusTextField.text == "" || statusTextField.text == nil) ?
            (statusLabel.text = statusTextEmpty) :
            (statusLabel.text = statusTextField.text)
            statusTextField.text = ""
    }
    
//MARK: - init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupStatusButton()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
}
//MARK: - setupStatusButton
extension ProfileHeaderView {
    private func setupStatusButton() {
        let backgroundImage = UIImage(named: "blue_pixel")
        let trasparentImage = backgroundImage!.alpha(0.8)
        
        setStatusButton.setBackgroundImage(backgroundImage, for: .normal)
        setStatusButton.setBackgroundImage(trasparentImage, for: .highlighted)
        setStatusButton.setTitleColor(.black, for: .highlighted)
        setStatusButton.layer.cornerRadius = 8
        setStatusButton.clipsToBounds = true
        
        logOutButton.setTitleColor(.systemRed, for: .highlighted)
        logOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        logOutButton.clipsToBounds = true
    }
}
//MARK: - setupViews
extension ProfileHeaderView {
    private func setupViews() {
        
        addSubview(avatarImage)
        addSubview(fullNameLabel)
        addSubview(logOutButton)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)
        
        avatarImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(16)
            make.leading.equalTo(16)
            make.size.equalTo(CGSize(width: 110, height: 110))
        }
        fullNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(16)
            make.leading.equalTo(avatarImage.snp.trailing).offset(16)
        }
        logOutButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(10)
            make.leading.equalTo(fullNameLabel.snp.trailing)
//            make.width.equalTo(100)
            make.trailing.equalTo(-16)
        }
        setStatusButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(avatarImage.snp.bottom).offset(46)
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(-16)
            make.height.equalTo(50)
        }
        statusTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(avatarImage.snp.trailing).offset(16)
            make.trailing.equalTo(-16)
            make.bottom.equalTo(setStatusButton.snp.top).offset(-16)
            make.height.equalTo(40)
        }
        statusLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(avatarImage.snp.trailing).offset(16)
            make.bottom.equalTo(statusTextField.snp.top).offset(-8)
        }
    }
}
