//
//  CategoriesViewController.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 07.04.2023.
//

import UIKit

final class CategoriesViewController: UIViewController {
    
    private struct UIConstants {
        static let padding: CGFloat = 10
        static let cellPadding: CGFloat = 40
        static let cellHieght: CGFloat = 160
        static let barButtonSize: CGFloat = 42
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        let sizeCell = CGSize(width: collection.bounds.width - UIConstants.cellPadding, height: UIConstants.cellHieght)
        layout.itemSize = sizeCell
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        collection.delegate = self
        collection.dataSource = self
        collection.indicatorStyle = .black
        collection.register(CategoriesViewCell.self, forCellWithReuseIdentifier: "CategoriesViewCell")
        return collection
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(profileButtonPressed), for: .touchUpInside)
        button.setImage(UIImage(systemName: "person.circle"), for: .normal)
        return button
    }()
    
    private let labelTexts = ["CHARACTERS", "PLANETS", "SHIPS", "VEHICLES", "FILMS"]
    private let categoryModel = [CharacterModel.self, PlanetModel.self] as [Any]
    private let logInModel = LogInModel()
    private let uploadUserDataModel = UploadUserDataModel()
    private let downloadImagesModel = DownloadImagesModel()
    private let getUserDataModel = GetUserDataModel()
    private lazy var profileBarButtonItem = UIBarButtonItem()
    private lazy var userID = ""
    
    
    // MARK: - override метод
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CATEGORIES"
        
        getUserDataModel.getUserID { uid in
            self.userID = uid
        }
        
        view.backgroundColor = UIColor.AppColors.backgroundColor
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        configureCollectionView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.configureProfileButton()
        }
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.AppColors.backgroundColor
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func configureProfileButton() {
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.widthAnchor.constraint(equalToConstant: UIConstants.barButtonSize).isActive = true
        profileButton.heightAnchor.constraint(equalTo: profileButton.widthAnchor).isActive = true
        profileButton.layer.cornerRadius = UIConstants.barButtonSize / 2
        profileButton.layer.masksToBounds = true
        profileBarButtonItem = UIBarButtonItem(customView: self.profileButton)
        self.navigationItem.rightBarButtonItem  = profileBarButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = .clear
        
        if let image = getSavedImage(named: "profileImage.png") {
            self.profileButton.setImage(image, for: .normal)
            self.profileBarButtonItem = UIBarButtonItem(customView: self.profileButton)
        } else {
            downloadImagesModel.downloadBarImage(userID: userID) { image in
                let buttonImage = image
                DispatchQueue.main.async {
                    self.profileButton.setImage(buttonImage, for: .normal)
                    self.profileBarButtonItem = UIBarButtonItem(customView: self.profileButton)
                    self.saveImage(image: buttonImage!)
                }
            }
        }
    }
    
    private func presentChosenCategoryView(_ modelIndex: Int) {
        let nextViewController = ObjectsListViewController()
        nextViewController.chosenCategory = modelIndex
        navigationController?.navigationItem.hidesBackButton = false
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    // MARK: - Работа с фото профиля
    
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
    
    
    // MARK: - @objc метод
    
    @objc private func profileButtonPressed() {
        let profileViewController = ProfileViewController()
        profileViewController.userID = userID
        self.navigationController?.pushViewController(profileViewController, animated: true)
    }
    
}

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelTexts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesViewCell", for: indexPath) as? CategoriesViewCell else { return .init() }
        cell.fillLabelWith(data: labelTexts[indexPath.row])
        cell.fillImageWith(imageName: labelTexts[indexPath.row].lowercased())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.1) {
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            cell?.alpha = 0.8
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.5) {
            cell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            cell?.alpha = 1.0
        }
        
        presentChosenCategoryView(indexPath.row)
    }
}
