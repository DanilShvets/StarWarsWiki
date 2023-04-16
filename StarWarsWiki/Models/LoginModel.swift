//
//  LoginModel.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 07.04.2023.
//

import Foundation
import Firebase

final class LogInModel {
    
    func logIn(email: String?, password: String?, complitionError: @escaping (String) -> ()) {
        guard let email = email, !email.isEmpty, isValidEmail(email: email) else {
            complitionError("Incorrect email")
            return
        }
        guard let password = password,  password.count >= 6 else {
            complitionError("Incorrect password")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                complitionError("Logging in")
                UserDefaults.standard.set(true, forKey: "userLoggedIn")
                UserDefaults.standard.synchronize()
            } else {
                complitionError(error!.localizedDescription)
            }
        }
    }
    
    func signUp(email: String?, username: String?, password: String?, complitionError: @escaping (String) -> ()) {
        guard let email = email, isValidEmail(email: email) else {
            complitionError("Incorrect email format")
            return
        }
        guard let username = username, isValidUsername(username: username) else {
//            complitionError("Имя пользователя должно быть не менее 3 символов и содержать только латинские буквы и цифры")
            complitionError("The username must contain at least 3 characters and contain only latin letters and numbers")
            return
        }
        guard let password = password, isValidPassword(password: password) else {
//            complitionError("Пароль должен быть не менее 6 символов и содержать только буквы, цифры и знаки . или _")
            complitionError("The password must be at least 6 characters long and contain only letters, numbers, and signs. or _")
            return
        }
        
        Auth.auth().fetchSignInMethods(forEmail: email, completion: { (signInMethods, error) in
            guard let signInMethods = signInMethods else {
                return
            }
            print("signInMethods:\(signInMethods).")
            
            if signInMethods[0] == "password" {
                complitionError("The email is already used")
            }
        })
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            guard let result = result else {
                return
            }
            
            let uid = result.user.uid
            UserDefaults.standard.set(uid, forKey: "current_user")
            
            let values = ["email": email, "password": password]
            
            let usersReferense = Database.database().reference().child("users")
            usersReferense.child(uid).updateChildValues(values)
            
            if error == nil {
                UserDefaults.standard.set(true, forKey: "userSignedUp")
                UserDefaults.standard.synchronize()
            } else {
                print("error: \(String(describing: error)).")
                complitionError(error!.localizedDescription)
            }
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidUsername(username: String) -> Bool {
        let user = "[A-Z0-9a-z]{3,100}"
        let userPred = NSPredicate(format:"SELF MATCHES %@", user)
        return userPred.evaluate(with: username)
    }
    
    func isValidPassword(password: String) -> Bool {
        let pass = "[A-Z0-9a-z._]{6,100}"
        let passPred = NSPredicate(format:"SELF MATCHES %@", pass)
        return passPred.evaluate(with: password)
    }
    
    func wrongUser(wrongUser: Bool, complitionError: (String) -> ()) {
        if wrongUser == true {
            complitionError("Incorrect email or password")
        }
        return
    }
    
//    func isUser(exist: Bool, complitionError: (String) -> ()) {
//        if exist == true {
//            complitionError("Такой пользователь существует")
//        } else {
//            complitionError("Вы успешно зарегистрированы!")
//        }
//        return
//    }
    
}
