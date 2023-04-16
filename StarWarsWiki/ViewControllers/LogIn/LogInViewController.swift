//
//  LogInController.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 07.04.2023.
//

import UIKit

final class LogInViewController: UIViewController, UITextFieldDelegate {
    
    struct UIConstants {
        static let spacing: CGFloat = 10
        static let borderWidth: CGFloat = 0.5
        static let cornerRadius: CGFloat = 10
        static let iconPadding: CGFloat = -30
        static let padding: CGFloat = 20
        static let activityIndicatorSize: CGFloat = 80
        static let stackSize: CGFloat = 120
        static let stackPaddingY: CGFloat = -50
        static let imageTopPadding: CGFloat = 20
    }
    
    private let logInModel = LogInModel()
    private let alert = UIAlertController(title: "Alert", message: "", preferredStyle: .alert)
    private let userIcon: UIImageView = UIImageView(image: UIImage(systemName: "person")!)
    private let passwordIcon: UIImageView = UIImageView(image: UIImage(systemName: "lock")!)
    private let loginLabel = UILabel()
    private lazy var emailInputView = UITextField()
    private lazy var passwordInputView = UITextField()
    private lazy var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        return button
    }()
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    lazy var textImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    // MARK: - override методы
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentLogIn()
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        hideKeyboard()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
    }
    
    private func userSignedUp() -> Bool {
        return UserDefaults.standard.bool(forKey: "userSignedUp")
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureView() {
        self.emailInputView.delegate = self
        self.passwordInputView.delegate = self
        configureUIView()
        configureSignUpButton()
        configureLogoImage()
    }
    
    private func presentLogIn() {
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        UserDefaults.standard.synchronize()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func reloadView() {
        presentLogIn()
        if userSignedUp() {
            alert.message = "You are successfully registered"
            self.present(alert, animated: true, completion: nil)
            UserDefaults.standard.set(false, forKey: "userSignedUp")
            UserDefaults.standard.synchronize()
        }
    }
    
    private func configureUserStack() -> UIStackView {
        let userStack = UIStackView(arrangedSubviews: [userIcon, emailInputView])
        view.addSubview(userStack)
        emailInputView.textColor = UIColor.AppColors.textColor
        emailInputView.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return userStack
    }
    
    private func configurePasswordStack() -> UIStackView {
        let passwordStack = UIStackView(arrangedSubviews: [passwordIcon, passwordInputView])
        view.addSubview(passwordStack)
        passwordInputView.textColor = UIColor.AppColors.textColor
        passwordInputView.isSecureTextEntry = true
        passwordInputView.textContentType = .oneTimeCode
        passwordInputView.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return passwordStack
    }
    
    private func configureUIView() {
        view.backgroundColor = UIColor.AppColors.backgroundColor
        
        let userStack = configureUserStack()
        let passwordStack = configurePasswordStack()
        
        [userIcon, passwordIcon].forEach {icon in
            icon.tintColor = .gray
            icon.heightAnchor.constraint(equalTo: userStack.heightAnchor, constant: UIConstants.iconPadding).isActive = true
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
        }
        
        [userStack, passwordStack].forEach { stack in
            stack.axis = .horizontal
            stack.spacing = UIConstants.spacing
            stack.alignment = .center
            stack.layer.borderColor = UIColor.AppColors.borderColor
            stack.layer.borderWidth = UIConstants.borderWidth
            stack.layer.cornerRadius = UIConstants.cornerRadius
            stack.isLayoutMarginsRelativeArrangement = true
            stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        }
       
        let stack = UIStackView(arrangedSubviews: [userStack, passwordStack])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = UIConstants.spacing
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: UIConstants.stackPaddingY).isActive = true
        stack.heightAnchor.constraint(equalToConstant: UIConstants.stackSize).isActive = true
        stack.widthAnchor.constraint(equalToConstant: view.bounds.width/1.2).isActive = true
        
        view.addSubview(logInButton)
        logInButton.setTitle("Log In", for: .normal)
        logInButton.backgroundColor = UIColor.AppColors.mainColor
        logInButton.tintColor = .white
        logInButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: view.frame.size.width/20)
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: UIConstants.padding).isActive = true
        logInButton.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
        logInButton.widthAnchor.constraint(equalToConstant: view.bounds.width/3).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: view.bounds.width/8).isActive = true
        logInButton.layer.cornerRadius = view.bounds.width/20
        
        view.addSubview(loginLabel)
        loginLabel.textAlignment = .left
        loginLabel.text = "Log In"
        loginLabel.textColor = UIColor.AppColors.mainColor
        loginLabel.font = UIFont.boldSystemFont(ofSize: view.frame.size.width/12)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -UIConstants.padding).isActive = true
        loginLabel.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
        loginLabel.heightAnchor.constraint(equalToConstant: view.frame.size.width/10).isActive = true
        
    }
    
    private func configureSignUpButton() {
        let mySelectedAttributedTitle = NSMutableAttributedString(string: "Join the dark side.  ",
                                                                  attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        signUpButton.setAttributedTitle(mySelectedAttributedTitle, for: .selected)

        mySelectedAttributedTitle.append(NSAttributedString(string: "Sign up",
                                                            attributes: [NSAttributedString.Key.foregroundColor : UIColor.AppColors.vaderColor]))
        signUpButton.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
        view.addSubview(signUpButton)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.padding).isActive = true
    }
    
    private func configureLogoImage() {
        view.addSubview(textImage)
        textImage.translatesAutoresizingMaskIntoConstraints = false
        textImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        textImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.imageTopPadding).isActive = true
        textImage.widthAnchor.constraint(equalToConstant: view.bounds.width / 4).isActive = true
        textImage.heightAnchor.constraint(equalToConstant: view.bounds.width / 4.5).isActive = true
        textImage.image = UIImage(named: "star-wars-logo-black")
    }
    
    private func showActivityIndicatory() {
        [logInButton, signUpButton, emailInputView, passwordInputView].forEach {object in
            object.isEnabled = false
        }
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: UIConstants.activityIndicatorSize, height: UIConstants.activityIndicatorSize)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.backgroundColor = UIColor.AppColors.textColor.withAlphaComponent(0.4)
        activityIndicator.widthAnchor.constraint(equalToConstant: UIConstants.activityIndicatorSize).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: UIConstants.activityIndicatorSize).isActive = true
        activityIndicator.layer.cornerRadius = UIConstants.cornerRadius
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            activityIndicator.stopAnimating()
            [self.logInButton, self.signUpButton, self.emailInputView, self.passwordInputView].forEach {object in
                object.isEnabled = true
            }
        }
    }
    
    private func presentSignUp() {
        let signUpController = SignUpViewController()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.AppColors.mainColor
        navigationItem.backBarButtonItem = backItem
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.pushViewController(signUpController, animated: true)
    }
    
    private func presentCategories() {
        let categoriesViewController = CategoriesViewController()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(categoriesViewController, animated: true)
    }
    
    
    // MARK: - UITextFields и клавиатура
    
    private func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func clearTextfields() {
        emailInputView.text?.removeAll()
        passwordInputView.text?.removeAll()
    }
    
    
    // MARK: - @objc методы
        
    @objc private func logInButtonPressed() {
        self.logInModel.logIn(email: emailInputView.text, password: passwordInputView.text) { error in
            if error != "Logging in" {
                self.alert.message = error
                self.present(self.alert, animated: true, completion: nil)
            } else {
                self.showActivityIndicatory()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if UserDefaults.standard.bool(forKey: "userLoggedIn") {
                self.presentCategories()
            }
        }
    }
    
    @objc private func signUpButtonPressed() {
        presentSignUp()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


