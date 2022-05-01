//
//  FeedViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 20.07.2021.
//

import UIKit

class FeedViewController: UIViewController {
    //MARK: - Props
    let viewModel: ViewOutput
    
    //MARK: - Localization
    let feedVCTitle = "bar_feed".localized()
    let feedTopBtn = "feed_top_btn".localized()
    let feedBotBtn = "feed_bot_btn".localized()
    let feedCheckField = "feed_check_field".localized()
    let feedCheckBtn = "feed_check_btn".localized()
    let feedCheckLabel = "feed_check_label".localized()
    let feedCheckLabelTrue = "feed_check_label_true".localized()
    let feedCheckLabelFalse = "feed_check_label_false".localized()
    
    //MARK: - Subviews
    lazy var buttonTop = MagicButton(title: feedTopBtn, titleColor: Palette.mainTextColor) {
        self.goToPosts()
    }
    
    lazy var buttonBot = MagicButton(title: feedBotBtn, titleColor: Palette.mainTextColor) {
        self.goToPosts()
    }
    
    lazy var checkTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        text.backgroundColor = Palette.feedBackgrdColor
        text.layer.cornerRadius = 8
        text.layer.borderWidth = 0.5
        text.layer.borderColor = UIColor.darkGray.cgColor
        text.placeholder = feedCheckField
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        return text
    }()
    
    let checkedLAbel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        title.numberOfLines = 0
        return title
    }()
    
    lazy var checkButton = MagicButton(title: feedCheckBtn, titleColor: Palette.mainTextColor) { [weak self] in
        if self?.checkTextField.text == "" {
            self?.checkedLAbel.textColor = Palette.mainTextColor
            self?.checkedLAbel.text = self?.feedCheckLabel
            return
        }
        
        let ifCheckedWord = self?.viewModel.check(word: self?.checkTextField.text ?? "")
        
        if ifCheckedWord! {
            self?.checkedLAbel.textColor = UIColor.systemGreen
            self?.checkedLAbel.text = self?.feedCheckLabelTrue
        } else {
            self?.checkedLAbel.textColor = UIColor.systemRed
            self?.checkedLAbel.text = self?.feedCheckLabelFalse
        }
        self?.checkTextField.text = ""
    }
    //MARK: - init
    
    init(viewModel: ViewOutput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtons()
        setupViews()
        
        self.title = feedVCTitle
        self.view.backgroundColor = Palette.feedBackgrdColor
    }
    //MARK: - methods
    
    func goToPosts() {
        let vc = PostViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - setupButtons
extension FeedViewController {
    func setupButtons() {
        buttonTop.setTitleColor(.purple, for: .highlighted)
        buttonBot.setTitleColor(.purple, for: .highlighted)
        checkButton.setTitleColor(.purple, for: .highlighted)
    }
}
//MARK: - setupViews
extension FeedViewController {
    func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [
            self.buttonTop,
            self.buttonBot,
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        
        self.view.addSubview(stackView)
        self.view.addSubview(checkTextField)
        self.view.addSubview(checkButton)
        self.view.addSubview(checkedLAbel)
        
        let constraints = [
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            checkTextField.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            checkTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkTextField.heightAnchor.constraint(equalToConstant: 40),
            
            checkButton.topAnchor.constraint(equalTo: checkTextField.bottomAnchor, constant: 10),
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            checkedLAbel.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 10),
            checkedLAbel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
