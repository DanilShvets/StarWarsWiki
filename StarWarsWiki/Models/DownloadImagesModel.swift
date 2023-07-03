//
//  DownloadImagesModel.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 02.07.2023.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import Firebase
import FirebaseStorage

final class DownloadImagesModel {
    
    private let storage = Storage.storage()
    
    func getNumberOfImages(userID: String, completion: @escaping (Int) -> ()) {
        let pathReference = storage.reference(withPath: "iconsFolder")
        var numberOfItems = 0
        pathReference.listAll { result, error in
            guard let result = result else { return }
            numberOfItems = result.items.count
            completion(numberOfItems)
            return
        }
    }
    
    func downloadBarImage(userID: String, completion: @escaping (UIImage?) -> ()) {
        let pathReference = storage.reference(withPath: "images/\(userID)/")
        let imageRef = pathReference.child("profileImage.jpg")
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
            } else {
                let image = UIImage(data: data!)
                completion(image)
                return
            }
        }
    }
    
    func downloadImage(imageNumber: Int, completion: @escaping (URL?) -> ()) {
//        let pathReference = storage.reference(withPath: "iconsFolder")
//        let imageRef = pathReference.child("\(imageNumber).jpg")
//
//        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//            if let error = error {
//            } else {
//                let image = UIImage(data: data!)
//                completion(image)
//                return
//            }
//        }
        
        let pathReference = storage.reference(withPath: "iconsFolder")

        let imageRef = pathReference.child("\(imageNumber).jpg")
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
    
}
