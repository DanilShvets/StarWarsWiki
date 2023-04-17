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
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        let sizeCell = CGSize(width: collection.bounds.width - UIConstants.cellPadding, height: UIConstants.cellHieght)
        layout.itemSize = sizeCell
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        collection.delegate = self
        collection.dataSource = self
        collection.indicatorStyle = .black
        collection.register(CategoriesViewCell.self, forCellWithReuseIdentifier: "CategoriesViewCell")
        return collection
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
        button.titleLabel?.textColor = UIColor.AppColors.signUpColor
        return button
    }()
    
    private let labelTexts = ["CHARACTERS", "PLANETS", "SHIPS", "VEHICLES", "FILMS"]
    private let categoryModel = [CharacterModel.self, PlanetModel.self] as [Any]
    
    
    // MARK: - override метод
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CATEGORIES"
        
        view.backgroundColor = UIColor.AppColors.backgroundColor
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Log Out", style: .done, target: self, action: #selector(logOutButtonPressed))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        
        configureCollectionView()
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
    
    private func presentChosenCategoryView(_ modelIndex: Int) {
        let nextViewController = ObjectsListViewController()
        nextViewController.chosenCategory = modelIndex
        navigationController?.navigationItem.hidesBackButton = false
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func presentLogInController() {
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        let logInViewController = LogInViewController()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationController?.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(logInViewController, animated: true)
    }
    
    
    // MARK: - @objc метод
    
    @objc private func logOutButtonPressed() {
        presentLogInController()
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
        presentChosenCategoryView(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
