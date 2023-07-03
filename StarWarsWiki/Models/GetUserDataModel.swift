//
//  GetUserDataModel.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 02.07.2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import Firebase
import FirebaseStorage

final class GetUserDataModel {
    
    private var ref: DatabaseReference!
    private let storage = Storage.storage()
    
    func getUsername(uid: String, completionHandler: @escaping (String) -> ()) {
        ref = Database.database(url: "https://usersdatabaseforapp-default-rtdb.firebaseio.com").reference()
        ref.child("users/\(uid)/username").getData(completion:  { error, snapshot in
            guard let snapshot = snapshot else {return}
            if snapshot.exists() {
                guard let username = snapshot.value else { return }
                completionHandler(username as! String)
            }
        })
    }
    
    func downloadImageURL(uid: String, completion: @escaping (URL?) -> ()) {
        let pathReference = storage.reference(withPath: "images/\(uid)/")
        let imageRef = pathReference.child("profileImage.jpg")
        var imageURL: URL?
        imageRef.downloadURL { url, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                imageURL = url
                completion(imageURL)
                return
            }
        }
    }
    
    func getUserID(completion: @escaping (String) -> ()) {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            completion(uid)
        }
    }
}
