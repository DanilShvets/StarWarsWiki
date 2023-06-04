//
//  ObjectPageViewController.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 11.04.2023.
//

import UIKit
import Kingfisher

final class ObjectPageViewController: UIViewController {
    
    private struct UIConstants {
        static let padding: CGFloat = 10
        static let imagePadding: CGFloat = 35
        static let labelHeight: CGFloat = 80
        static let imageCornerRadius: CGFloat = 10
        static let fontSize: CGFloat = 30
        static let headersFontSize: CGFloat = 25
        static let headersLabelHeight: CGFloat = 30
        static let textFontSize: CGFloat = 20
        static let textLabelHeight: CGFloat = 60
    }
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var name: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: UIConstants.fontSize)
        label.numberOfLines = 0
        label.textColor = UIColor.AppColors.textColor
        return label
    }()
    
    private var firstHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: UIConstants.headersFontSize)
        label.numberOfLines = 0
        label.textColor = UIColor.AppColors.textColor
        label.tag = 0
        return label
    }()
    
    private var secondHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: UIConstants.headersFontSize)
        label.numberOfLines = 0
        label.textColor = UIColor.AppColors.textColor
        label.tag = 1
        return label
    }()
    
    private var firstText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: UIConstants.textFontSize)
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.AppColors.textColor
        label.tag = 0
        return label
    }()
    
    private var secondText: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: UIConstants.textFontSize)
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.AppColors.textColor
        label.tag = 1
        return label
    }()
    
    private let imagesURLs = ImagesURLs()
    private var urlDict: [[String: String]] = [[:]]
    private let headers = [["Gender", "Birth year"], ["Terrain", "Population"] , ["Model", "Crew"], ["Model", "Crew"], ["Director", "Release date"]]
    
    var objectName = ""
    var objectData = [String]()
    var chosenCategory = 0
    
    
    // MARK: - override метод
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.AppColors.backgroundColor
        
        urlDict = [imagesURLs.charactersImages, imagesURLs.planetsImages, imagesURLs.shipsImages, imagesURLs.vehiclesImages, imagesURLs.filmsImages]
        
        configureImageView()
        configureImage(objectName, chosenCategory)
        configureNameLabel()
        configureHeadersLabel()
        configureForDarthVader()
        configureForAnakin()
        
        if chosenCategory == 4 {
            secondText.text = convertDateFormatter(date: secondText.text ?? "")
        }
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureImageView() {
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.padding).isActive = true
        image.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.imagePadding).isActive = true
        image.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.imagePadding).isActive = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor).isActive = true
        image.clipsToBounds = true
    }
    
    private func configureNameLabel() {
        view.addSubview(name)
        name.translatesAutoresizingMaskIntoConstraints = false
        name.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: UIConstants.padding).isActive = true
        name.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
        name.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
        name.text = objectName
    }
    
    private func configureHeadersLabel() {
        [firstHeader, secondHeader].forEach {object in
            view.addSubview(object)
            object.translatesAutoresizingMaskIntoConstraints = false
            object.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            object.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
            object.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
            object.text = headers[chosenCategory][object.tag]
        }
        
        [firstText, secondText].forEach {object in
            view.addSubview(object)
            object.translatesAutoresizingMaskIntoConstraints = false
            object.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            object.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10.0).isActive = true
            object.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10.0).isActive = true
            object.text = objectData[object.tag]
        }
        
        firstHeader.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 2 * UIConstants.padding).isActive = true
        firstText.topAnchor.constraint(equalTo: firstHeader.bottomAnchor, constant: UIConstants.padding).isActive = true
        secondHeader.topAnchor.constraint(equalTo: firstText.bottomAnchor, constant: 2 * UIConstants.padding).isActive = true
        secondText.topAnchor.constraint(equalTo: secondHeader.bottomAnchor, constant: UIConstants.padding).isActive = true
    }
    
    private func configureForDarthVader() {
        if name.text == "Darth Vader" {
            [name, firstHeader, secondHeader, firstText, secondText].forEach {object in
                object.textColor = UIColor.AppColors.vaderColor
            }
        }
    }
    
    private func configureForAnakin() {
        if name.text == "Anakin Skywalker" {
            [name, firstHeader, secondHeader, firstText, secondText].forEach {object in
                object.textColor = UIColor.AppColors.mainColor
            }
        }
    }
    
    private func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "dd.MM.yyy"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        let timeStamp = dateFormatter.string(from: date ?? Date())

        return timeStamp
    }
    
    private func configureImage(_ objectName: String, _ chosenCategory: Int) {
        image.kf.setImage(with: URL(string: urlDict[chosenCategory][objectName] ?? ""))
    }
    
    
}
