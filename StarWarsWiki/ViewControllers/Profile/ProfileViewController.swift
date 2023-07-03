//
//  ProfileViewController.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 02.07.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private struct UIConstants {
        static let padding: CGFloat = 10
        static let cellPadding: CGFloat = 40
        static let bigPadding: CGFloat = 30
        static let imageWidth: CGFloat = 70
        static let imageCornerRadius: CGFloat = 35
    }
    
    private lazy var numberOfIcons = 0
    private lazy var iconsDict = [Int: UIImage]()
    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .lightGray
        return image
    }()
    private let changePhotoLabel = UILabel()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        let sizeCell = CGSize(width: collection.bounds.width / 4, height: collection.bounds.width / 4)
        layout.itemSize = sizeCell
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = UIConstants.padding
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.register(ProfilePhotosCell.self, forCellWithReuseIdentifier: "ProfilePhotosCell")
        return collection
    }()
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let logInModel = LogInModel()
    private let downloadImagesModel = DownloadImagesModel()
    private let getUserDataModel = GetUserDataModel()
    private let uploadUserDataModel = UploadUserDataModel()
    var userID = ""
    
    
    // MARK: - override методы
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.AppColors.backgroundColor
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        getNumberOfIcons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureProfileImage()
        configureChangePhotoLabel()
        getPhotoFromFirebase()
        configureLogOutButton()
        configureCollectionView()
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureProfileImage() {
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
        profileImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.bigPadding).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: view.bounds.width / 2.5).isActive = true
        profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor).isActive = true
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = view.bounds.width / 5
    }
    
    private func configureLogOutButton() {
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logOutButton)
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.backgroundColor = UIColor.AppColors.vaderColor
        logOutButton.tintColor = .white
        logOutButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: view.frame.size.width/20)
        logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.bigPadding).isActive = true
        logOutButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: view.bounds.width/3).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: view.bounds.width/8).isActive = true
        logOutButton.layer.cornerRadius = view.bounds.width/20
    }
    
    private func configureChangePhotoLabel() {
        view.addSubview(changePhotoLabel)
        changePhotoLabel.textAlignment = .left
        changePhotoLabel.text = "Change photo:"
        changePhotoLabel.textColor = UIColor.AppColors.mainColor
        changePhotoLabel.font = UIFont.boldSystemFont(ofSize: view.frame.size.width/15)
        changePhotoLabel.translatesAutoresizingMaskIntoConstraints = false
        changePhotoLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: UIConstants.bigPadding).isActive = true
        changePhotoLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.bigPadding).isActive = true
        changePhotoLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.bigPadding).isActive = true
        changePhotoLabel.heightAnchor.constraint(equalToConstant: view.frame.size.width/10).isActive = true
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.AppColors.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: UIConstants.cellPadding).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -UIConstants.cellPadding).isActive = true
        collectionView.topAnchor.constraint(equalTo: changePhotoLabel.bottomAnchor, constant: UIConstants.bigPadding).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: logOutButton.topAnchor, constant: -UIConstants.bigPadding).isActive = true
    }
    
    private func presentLogInController() {
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        let logInViewController = LogInViewController()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(logInViewController, animated: true)
    }
    
    private func getNumberOfIcons() {
        self.downloadImagesModel.getNumberOfImages(userID: self.userID) { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.numberOfIcons = result
                self.collectionView.reloadData()
            }
        }
    }
    
    
    // MARK: - Работа с фото профиля
    
    private func getPhotoFromFirebase() {
        profileImage.image = getSavedImage(named: "profileImage.png")
    }
    
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
    
    private func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func deleteProfileImage(withName fileName: String) {
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let filePath = docDir.appendingPathComponent(fileName)
        do {
            try FileManager.default.removeItem(at: filePath)
            return
        }
        catch {
            print("Error while deleting file")
        }
        return
    }
    
    
    
    // MARK: - @objc методы
    
    @objc private func logOutButtonPressed() {
        logInModel.signOut { success in
            if success {
                UserDefaults.standard.set(false, forKey: "userLoggedIn")
                UserDefaults.standard.removeObject(forKey: "userID")
                self.deleteProfileImage(withName: "profileImage.png")
                self.presentLogInController()
            }
        }
    }
    
}



// MARK: - Работа с коллекцией

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfIcons
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfilePhotosCell", for: indexPath) as? ProfilePhotosCell else { return .init() }
        if iconsDict[indexPath.row] == nil {
            downloadImagesModel.downloadImage(imageNumber: indexPath.row + 1) { url in
                DispatchQueue.main.async {
                    cell.fillImageWith(url: url) { image in
                        self.iconsDict[indexPath.row] = image
                    }
                }
            }
        } else {
            cell.fillImageWith(icon: iconsDict[indexPath.row]!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if iconsDict[indexPath.row] != nil {
            let currentImage = iconsDict[indexPath.row]
            profileImage.image = currentImage
            saveImage(image: currentImage!)
            uploadUserDataModel.sendProfileImageToFirebase(uid: userID, photo: currentImage!.jpegData(compressionQuality: 1.0)!) { error in
                
            }
        }
    }
}

