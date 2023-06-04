//
//  CharactersListViewController.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 09.04.2023.
//

import UIKit

final class ObjectsListViewController: UIViewController {
    
    private struct UIConstants {
        static let padding: CGFloat = 10
        static let tableCellHeight: CGFloat = 65
        static let cornerRadius: CGFloat = 10
        static let activityIndicatorSize: CGFloat = 80
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.indicatorStyle = .black
        tableView.separatorStyle = .singleLine
        tableView.register(ObjectsListViewCell.self, forCellReuseIdentifier: ObjectsListViewCell.cellId)
        return tableView
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)
        button.titleLabel?.textColor = UIColor.AppColors.signUpColor
        return button
    }()
    
    private var objectsFromResponse = Dictionary<String, [String]>()
    private var sortedArray = [String]()
    private let urlCategories = ["people", "planets", "starships", "vehicles", "films"]
    private let labelTexts = ["CHARACTERS", "PLANETS", "SHIPS", "VEHICLES", "FILMS"]
    private let activityIndicator = UIActivityIndicatorView()
    private var shouldHideActivityIndicator = false
    
    var chosenCategory = 0
    
    
    // MARK: - override методы
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.AppColors.backgroundColor
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.title = labelTexts[chosenCategory]
        configureTableView()
        showActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.global().async {
            self.parseDataForChosenCategory()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.reloadTableView()
            }
        }
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor.AppColors.backgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func presentChosenCategoryView(_ objectName: String) {
        let nextViewController = ObjectPageViewController()
        nextViewController.objectName = objectName
        nextViewController.chosenCategory = chosenCategory
        nextViewController.objectData = objectsFromResponse[objectName] ?? ["", ""]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    private func reloadTableView() {
        sortedArray = objectsFromResponse.map({ $0.key }).sorted(by: <)
        if sortedArray.count == 0 {
            configureRefreshButton()
        } else {
            shouldHideActivityIndicator = true
        }
        tableView.reloadData()
    }
    
    private func parseDataForChosenCategory() {
        if chosenCategory != 4 {
            for page in 1...3 {
                NetworkManager.shared.parseObject(chosenCategory, page, urlCategories[chosenCategory]) { result in
                    self.objectsFromResponse.merge(result)  { (current, _) in current }
                }
            }
        } else {
            NetworkManager.shared.parseObject(chosenCategory, 1, urlCategories[chosenCategory]) { result in
                self.objectsFromResponse.merge(result)  { (current, _) in current }
            }
        }
    }
    
    private func configureRefreshButton() {
        shouldHideActivityIndicator = true
        showActivityIndicator()
        let refreshBarButtonItem = UIBarButtonItem(title: "Refresh", style: .done, target: self, action: #selector(refreshButtonPressed))
        self.navigationItem.rightBarButtonItem  = refreshBarButtonItem
    }
    
    private func showActivityIndicator() {
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
        if shouldHideActivityIndicator {
            activityIndicator.stopAnimating()
        }
    }
    
    @objc private func refreshButtonPressed() {
        shouldHideActivityIndicator = false
        showActivityIndicator()
        DispatchQueue.global().async {
            self.parseDataForChosenCategory()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.shouldHideActivityIndicator = true
                self.reloadTableView()
                if self.sortedArray.count != 0 {
                    self.navigationItem.rightBarButtonItem = nil
                }
            }
        }
    }
    
}

extension ObjectsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ObjectsListViewCell.cellId, for: indexPath) as? ObjectsListViewCell else { return .init() }
        
        cell.fillLabelWith(data: sortedArray[indexPath.row])
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.selectionStyle = .blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentChosenCategoryView(sortedArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIConstants.tableCellHeight
    }
    
}

