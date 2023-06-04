//
//  ObjectPageViewController.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 11.04.2023.
//

import UIKit
import Kingfisher

final class ObjectPageViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
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
        static let buttonSize: CGFloat = 35
    }
    
    private lazy var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
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
    
    private let largeConfig = UIImage.SymbolConfiguration(pointSize: UIConstants.buttonSize, weight: .bold, scale: .large)
    private let imagesURLs = ImagesURLs()
    private var urlDict: [[String: String]] = [[:]]
    private let headers = [["Gender", "Birth year"], ["Terrain", "Population"] , ["Model", "Crew"], ["Model", "Crew"], ["Director", "Release date"]]
    private var statusBarHeight: CGFloat = 0.0
    private var navigationBarHeight: CGFloat = 0.0
    
    var objectName = ""
    var objectData = [String]()
    var chosenCategory = 0
    
    
    // MARK: - override метод
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.AppColors.backgroundColor
        
        urlDict = [imagesURLs.charactersImages, imagesURLs.planetsImages, imagesURLs.shipsImages, imagesURLs.vehiclesImages, imagesURLs.filmsImages]
        
        if !UserDefaults.standard.bool(forKey: "isInfoShown") {
            configureInfoButton()
        }
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureInfoButton() {
        view.addSubview(infoButton)
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.padding).isActive = true
        infoButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -2*UIConstants.padding).isActive = true
        infoButton.widthAnchor.constraint(equalToConstant: UIConstants.buttonSize).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: UIConstants.buttonSize).isActive = true
        let infoButtonImage = UIImage(systemName: "info.circle", withConfiguration: largeConfig)
        infoButton.setImage(infoButtonImage, for: .normal)
        infoButton.tintColor = .systemGray
        infoButton.imageView?.contentMode = .scaleAspectFill
    }
    
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
        name.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
        name.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
        name.text = objectName
    }
    
    private func configureHeadersLabel() {
        [firstHeader, secondHeader].forEach {object in
            view.addSubview(object)
            object.translatesAutoresizingMaskIntoConstraints = false
            object.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            object.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
            object.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
            object.text = headers[chosenCategory][object.tag]
        }
        
        [firstText, secondText].forEach {object in
            view.addSubview(object)
            object.translatesAutoresizingMaskIntoConstraints = false
            object.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            object.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.padding).isActive = true
            object.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.padding).isActive = true
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
    
    private func presentImageViewController() {
        let imageViewController = ImageViewController(topAreaHeight: statusBarHeight + navigationBarHeight, navigationBarHeight: navigationBarHeight, image: image.image ?? UIImage())
        present(imageViewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        false
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        print("Image tapped")
        presentImageViewController()
    }
    
    @objc private func infoButtonPressed() {
        let infoViewController = InfoViewController()
        infoViewController.modalPresentationStyle = .popover
        infoViewController.preferredContentSize = CGSize(width: 200, height: 110)
        guard let presentationVC = infoViewController.popoverPresentationController else {return}
        presentationVC.delegate = self
        presentationVC.sourceView = infoButton
        presentationVC.permittedArrowDirections = .down
        presentationVC.sourceRect = CGRect(x: infoButton.bounds.midX, y: infoButton.bounds.minY, width: 0, height: 0)
        present(infoViewController, animated: true)
        presentationVC.passthroughViews = [infoButton]
        
        if infoButton.imageView?.image == UIImage(systemName: "info.circle", withConfiguration: largeConfig) {
            let infoButtonImage = UIImage(systemName: "xmark.circle", withConfiguration: largeConfig)
            infoButton.setImage(infoButtonImage, for: .normal)
        } else {
            UserDefaults.standard.set(true, forKey: "isInfoShown")
            presentedViewController?.dismiss(animated: true)
            infoButton.isHidden = true
        }
    }
    
}
