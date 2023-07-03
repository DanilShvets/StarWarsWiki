//
//  SignUpViewController.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 13.04.2023.
//

import UIKit

final class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private struct UIConstants {
        static let spacing: CGFloat = 10
        static let borderWidth: CGFloat = 0.5
        static let cornerRadius: CGFloat = 10
        static let iconPadding: CGFloat = -30
        static let padding: CGFloat = 10
    }
    
    private let logInModel = LogInModel()
    private let uploadUserDataModel = UploadUserDataModel()
    private let alert = UIAlertController(title: "Alert", message: "", preferredStyle: .alert)
    private let emailIcon: UIImageView = UIImageView(image: UIImage(systemName: "mail")!)
    private let userIcon: UIImageView = UIImageView(image: UIImage(systemName: "person")!)
    private let passwordIcon: UIImageView = UIImageView(image: UIImage(systemName: "lock")!)
    private let signUpLabel = UILabel()
    private lazy var emailInputView = UITextField()
    private lazy var usernameInputView = UITextField()
    private lazy var passwordInputView = UITextField()
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - override метод
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        hideKeyboard()
        configureView()
    }
    
    private func userSignedUp() -> Bool {
        return UserDefaults.standard.bool(forKey: "userSignedUp")
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureView() {
        self.emailInputView.delegate = self
        self.usernameInputView.delegate = self
        self.passwordInputView.delegate = self
        configureUIView()
    }
    
    private func configureUIView() {
        view.backgroundColor = UIColor.AppColors.backgroundColor
        
        view.addSubview(signUpLabel)
        signUpLabel.textAlignment = .left
        signUpLabel.text = "Sign Up"
        signUpLabel.textColor = UIColor.AppColors.mainColor
        signUpLabel.font = UIFont.boldSystemFont(ofSize: view.frame.size.width/12)
        signUpLabel.translatesAutoresizingMaskIntoConstraints = false
        signUpLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2 * UIConstants.padding).isActive = true
        signUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpLabel.widthAnchor.constraint(equalToConstant: view.bounds.width/1.2).isActive = true
        signUpLabel.heightAnchor.constraint(equalToConstant: view.frame.size.width/10).isActive = true
        
        let userStack = UIStackView(arrangedSubviews: [userIcon, usernameInputView])
        usernameInputView.textColor = UIColor.AppColors.textColor
        usernameInputView.attributedPlaceholder = NSAttributedString(string: "Username",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        
        let emailStack = UIStackView(arrangedSubviews: [emailIcon, emailInputView])
        emailInputView.textColor = UIColor.AppColors.textColor
        emailInputView.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let passwordStack = UIStackView(arrangedSubviews: [passwordIcon, passwordInputView])
        passwordInputView.textColor = UIColor.AppColors.textColor
        passwordInputView.isSecureTextEntry = true
        passwordInputView.textContentType = .oneTimeCode
        passwordInputView.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        [userStack, emailStack, passwordStack].forEach {stack in
            stack.axis = .horizontal
            stack.spacing = UIConstants.spacing
            stack.alignment = .center
            view.addSubview(stack)
            stack.layer.borderColor = UIColor.AppColors.borderColor
            stack.layer.borderWidth = UIConstants.borderWidth
            stack.layer.cornerRadius = UIConstants.cornerRadius
            stack.isLayoutMarginsRelativeArrangement = true
            stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        }
        
        [userIcon, emailIcon, passwordIcon].forEach {icon in
            icon.tintColor = .gray
            icon.heightAnchor.constraint(equalTo: emailStack.heightAnchor, constant: UIConstants.iconPadding).isActive = true
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
        }
        
        let stack = UIStackView(arrangedSubviews: [userStack, emailStack, passwordStack])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = UIConstants.spacing
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: UIConstants.padding).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 180).isActive = true
        stack.widthAnchor.constraint(equalToConstant: view.bounds.width/1.2).isActive = true
        
        view.addSubview(signUpButton)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.backgroundColor = UIColor.AppColors.mainColor
        signUpButton.tintColor = .white
        signUpButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: view.frame.size.width/20)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: UIConstants.padding).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: view.bounds.width/3).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: view.bounds.width/8).isActive = true
        signUpButton.layer.cornerRadius = view.bounds.width/20
    }
    
    private func presentCategories(withUserID userID: String) {
        let username = self.usernameInputView.text!
        DispatchQueue.global(qos: .background).async {
            self.uploadUserDataModel.sendProfileDataToFirebase(uid: userID, username: username)
            self.uploadUserDataModel.sendProfileImageToFirebase(uid: userID, photo: (UIImage(named: "captainRex")?.jpegData(compressionQuality: 1.0))!) { error in
                
            }
        }
        saveImage(image: UIImage(named: "captainRex")!)
        let categoriesViewController = CategoriesViewController()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(categoriesViewController, animated: true)
    }
    
    
    // MARK: - Сохранение фото профиля
    
    private func saveImage(image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 1.0) ?? image.pngData() else {
            return
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        do {
            try data.write(to: directory.appendingPathComponent("profileImage.png")!)
            return
        } catch {
            print(error.localizedDescription)
            return
        }
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
    
    
    // MARK: - @objc методы
    
    @objc private func signUpButtonPressed() {
        signUpButton.loadingIndicator(show: true)
        signUpButton.setTitle("", for: .normal)
        self.logInModel.createNewUser(username: self.usernameInputView.text, email: self.emailInputView.text, password: self.passwordInputView.text) { result, error in
            if error == "" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.signUpButton.loadingIndicator(show: false)
                    self.signUpButton.setTitle("Sign Up", for: .normal)
                    self.presentCategories(withUserID: result)
                }
            } else {
                self.signUpButton.loadingIndicator(show: false)
                self.signUpButton.setTitle("Sign Up", for: .normal)
                let alert = UIAlertController(title: "Alert", message: error, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
