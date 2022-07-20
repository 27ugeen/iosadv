//
//  LogInViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 31.07.2021.
//

import Foundation
import UIKit

class LogInViewController: UIViewController, LoginViewInputProtocol {
    //MARK: - props
    private let loginViewModel: LoginViewModel
    private let appCoordinator: AppCoordinator
    private let localAuthorizationService: LocalAuthorizationService
    
    private var authError: String = ""
    private var currentStrategy: AuthorizationStrategy = .logIn
    private var isSignedUp: Bool = UserDefaults.standard.bool(forKey: "isSignedUp")
    private var isUserExists: Bool = true {
        willSet {
            if newValue {
                loginButton.setTitle(titleLogin, for: .normal)
                switchLoginButton.setTitle(titleSwitchToCreate, for: .normal)
            } else {
                loginButton.setTitle(titleCreate, for: .normal)
                switchLoginButton.setTitle(titleSwitchToLogin, for: .normal)
            }
        }
    }
    //MARK: - subviews
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private let contentView: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    private let logoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "trident")
        image.backgroundColor = .white
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    private lazy var loginTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .systemGray6
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 8
        text.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        text.tintColor = UIColor(named: "myAccentColor")
        text.autocapitalizationType = .none
        text.placeholder = loginPlaceholder
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        return text
    }()
    
    private lazy var passwordTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .systemGray6
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 8
        text.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        text.tintColor = UIColor(named: "myAccentColor")
        text.autocapitalizationType = .none
        text.placeholder = passwordPlaceholder
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.isSecureTextEntry = true
        return text
    }()
    
    private lazy var loginButton = MagicButton(title: titleLogin, titleColor: Palette.btnWithBorderLableColor) {
        self.goToProfile()
    }
    
    private lazy var switchLoginButton = MagicButton(title: titleSwitchToCreate, titleColor: Palette.btnWithoutBorderLableColor) {
        self.isUserExists = !self.isUserExists
    }
    //MARK: - localization
    private let titleLogin = "login_user".localized()
    private let titleSwitchToCreate = "switch_to_create".localized()
    private let titleCreate = "create_user".localized()
    private let authMessage = "input_login_password".localized()
    private let titleSwitchToLogin = "switch_to_login".localized()
    private let loginPlaceholder = "login_placeholder".localized()
    private let passwordPlaceholder = "password_placeholder".localized()
    private let emptyFields = "empty_fields".localized()
    
    //MARK: - init
    init(loginViewModel: LoginViewModel, coordinator: AppCoordinator, localAuthorizationService: LocalAuthorizationService) {
        self.loginViewModel = loginViewModel
        self.appCoordinator = coordinator
        self.localAuthorizationService = localAuthorizationService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkBiometricAuthorizationPossibility()
        setupLoginButton()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - methods
    private func goToProfile() {
        if !isUserExists {
            currentStrategy = .newUser
        } else {
            currentStrategy = .logIn
        }

        if(!(loginTextField.text ?? "").isEmpty && !(passwordTextField.text ?? "").isEmpty) {
            userTryAuthorize(withStrategy: currentStrategy)
        } else {
            showAlert(message: emptyFields)
        }
    }
    
    func userTryAuthorize(withStrategy: AuthorizationStrategy) {
        switch currentStrategy {
        case .logIn:
            loginViewModel.signInUser(userLogin: loginTextField.text ?? "", userPassword: passwordTextField.text ?? "") { error in
                if let unwrappedError = error {
                    self.authError = unwrappedError
                    print("Error: \(unwrappedError)")
                    self.showAlert(message: unwrappedError)
                }
            }
        case .newUser:
            loginViewModel.createUser(userLogin: loginTextField.text ?? "", userPassword: passwordTextField.text ?? "") { error in
                if let unwrappedError = error {
                    self.authError = unwrappedError
                    print("Error: \(unwrappedError)")
                    self.showAlert(message: unwrappedError)
                }
            }
        }
        if authError == "" {
            let tabBC = appCoordinator.start()
            self.navigationController?.pushViewController(tabBC, animated: true)
            print("Current user: \(String(describing: self.loginTextField.text)) is signed in")
        }
        authError = ""
    }
}
//MARK: - checkBAPossibility
extension LogInViewController {
    private func checkBiometricAuthorizationPossibility() {
        self.localAuthorizationService.checkBiometricAuthorizePossibility()
        guard self.localAuthorizationService.biometryType != nil else { return }
        
        if isSignedUp {
            let authVC = AuthorizationViewController(localAuthorizationService: localAuthorizationService)
            authVC.modalPresentationStyle = .overFullScreen
            authVC.viewTappedAction = {
                self.localAuthorizationService.authorizeIfPossible() { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let ok):
                            print("Success: \(ok)")
                            let userId = UserDefaults.standard.string(forKey: "userId")
                            if let currentId = userId {
                                let currentUser = self.loginViewModel.getCurrentUser(currentId)
                                let tabBC = self.appCoordinator.start()
                                self.navigationController?.pushViewController(tabBC, animated: true)
                                print("Current user: \(String(describing: currentUser.email)) is signed in")
                            }
                        case .failure(let err):
                            self.showAlert(message: "\(self.authMessage)")
                            print("Err: \(err.localizedDescription)")
                        }
                        print("Result: \(result)")
                    }
                }
            }
            self.present(authVC, animated: true)
        } else {
            print("No user is signed in.")
        }
    }
}
//MARK: - setupLoginButton
extension LogInViewController {
    private func setupLoginButton() {
        let backgroundImage = UIImage(named: "blue_pixel")
        let trasparentImage = backgroundImage!.alpha(0.8)
        
        loginButton.setBackgroundImage(backgroundImage, for: .normal)
        loginButton.setBackgroundImage(trasparentImage, for: .highlighted)
        loginButton.setTitleColor(.black, for: .highlighted)
        loginButton.layer.cornerRadius = 8
        loginButton.clipsToBounds = true
        
        switchLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
}
//MARK: - setupViews
extension LogInViewController {
    private func setupViews() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = Palette.appTintColor
        self.view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(logoImage)
        contentView.addSubview(loginTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)
        contentView.addSubview(switchLoginButton)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImage.widthAnchor.constraint(equalToConstant: 150),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor),
            
            loginTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginTextField.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 100),
            loginTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            switchLoginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            switchLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5),
            switchLoginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchLoginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            switchLoginButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
//MARK: - UNUserNotificationCenterDelegate
extension LogInViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("default action")
        case "actionUpdates":
            print("need updates")
            showAlert(message: "Need install updates")
        case "actionCancel":
            print("action canceled")
        default:
            break
        }
        completionHandler()
    }
}
//MARK: - setupKeyboard
private extension LogInViewController {
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}
