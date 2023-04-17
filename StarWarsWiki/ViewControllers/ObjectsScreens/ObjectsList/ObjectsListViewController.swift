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
        static let delayTableViewConfigure: CGFloat = 8
        static let delayArraySort: CGFloat = 7
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
    
    private let categories = (CharactersResponse.self, PlanetsResponse.self, ShipsResponse.self, VehiclesResponse.self, FilmsResponse.self)
    private var objectsFromResponse = Dictionary<String, [String]>()
    private var sortedArray = [String]()
    private let urlCategories = ["people", "planets", "starships", "vehicles", "films"]
    private let labelTexts = ["CHARACTERS", "PLANETS", "SHIPS", "VEHICLES", "FILMS"]
    private let activityIndicator = UIActivityIndicatorView()
    
    var chosenCategory = 0
    
    
    // MARK: - override методы
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.AppColors.backgroundColor
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.title = labelTexts[chosenCategory]
        
        configureTableView()
        parseDataForChosenCategory()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.sortedArray.count == 0 {
                self.configureRefreshButton()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    
    // MARK: - Обработка запроса
    
    private func parseCharacter(_ pageNumber: Int, _ urlCategory: String){
        let urlString = "https://swapi.dev/api/\(urlCategory)/?page=\(pageNumber)"
        guard let urlRequest = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {return}
            
            do {
                switch self.chosenCategory {
                case 0:
                    let charactersResponse = try JSONDecoder().decode(self.categories.0, from: data)
                    charactersResponse.results.forEach { item in
                        self.objectsFromResponse.updateValue([item.gender, item.birth_year], forKey: item.name)
                    }
                    self.reloadTableView()
                case 1:
                    let charactersResponse = try JSONDecoder().decode(self.categories.1, from: data)
                    charactersResponse.results.forEach { item in
                        self.objectsFromResponse.updateValue([item.terrain, item.population], forKey: item.name)
                    }
                    self.reloadTableView()
                case 2:
                    let charactersResponse = try JSONDecoder().decode(self.categories.2, from: data)
                    charactersResponse.results.forEach { item in
                        self.objectsFromResponse.updateValue([item.model, item.crew], forKey: item.name)
                    }
                    self.reloadTableView()
                case 3:
                    let charactersResponse = try JSONDecoder().decode(self.categories.3, from: data)
                    charactersResponse.results.forEach { item in
                        self.objectsFromResponse.updateValue([item.model, item.crew], forKey: item.name)
                    }
                    self.reloadTableView()
                case 4:
                    let charactersResponse = try JSONDecoder().decode(self.categories.4, from: data)
                    charactersResponse.results.forEach { item in
                        self.objectsFromResponse.updateValue([item.director, item.release_date], forKey: item.title)
                    }
                    self.reloadTableView()
                default:
                    let charactersResponse = try JSONDecoder().decode(self.categories.0, from: data)
                    charactersResponse.results.forEach { item in
                        self.objectsFromResponse.updateValue([item.homeworld, item.birth_year], forKey: item.name)
                    }
                    self.reloadTableView()
                }
            } catch  {
                print(error)
            }
        }.resume()
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
        self.sortedArray = self.objectsFromResponse.map({ $0.key }).sorted(by: <)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
    }
    
    private func parseDataForChosenCategory() {
        if chosenCategory != 4 {
            for page in 1...3 {
                parseCharacter(page, urlCategories[chosenCategory])
            }
        } else {
            parseCharacter(1, urlCategories[chosenCategory])
        }
        reloadTableView()
    }
    
    private func configureRefreshButton() {
        let refreshBarButtonItem = UIBarButtonItem(title: "Refresh", style: .done, target: self, action: #selector(refreshButtonPressed))
        self.navigationItem.rightBarButtonItem  = refreshBarButtonItem
    }
    
    @objc private func refreshButtonPressed() {
        parseDataForChosenCategory()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.sortedArray.count != 0 {
                self.navigationItem.rightBarButtonItem = nil
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
