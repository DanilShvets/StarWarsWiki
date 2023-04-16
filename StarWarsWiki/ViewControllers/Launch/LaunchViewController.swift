//
//  LaunchViewController.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 15.04.2023.
//

import UIKit

final class LaunchViewController: UIViewController {
    
    private struct UIConstants {
        static let topPadding: CGFloat = 100
    }
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var textImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    // MARK: - override метод
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        configureView()
        animateLogo()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dismissLaunchView()
        }
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureView() {
        view.backgroundColor = UIColor.AppColors.backgroundColor
        
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        image.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        image.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        image.image = UIImage(named: "tatooineLaunch")
        
        view.addSubview(textImage)
        textImage.translatesAutoresizingMaskIntoConstraints = false
        textImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        textImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.topPadding).isActive = true
        textImage.widthAnchor.constraint(equalToConstant: view.bounds.width / 2).isActive = true
        textImage.heightAnchor.constraint(equalToConstant: view.bounds.width / 2.5).isActive = true
        textImage.image = UIImage(named: "star-wars-logo-white")
    }
    
    private func animateLogo() {
        textImage.transform = CGAffineTransform(translationX: 0, y: 50)
        UIView.animate(withDuration: 0.5) {
            self.textImage.transform = .identity
        }
        
        textImage.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.textImage.alpha = 1
        }
    }
    
    private func dismissLaunchView() {
        UIView.animate(withDuration: 0.5) {
            self.textImage.alpha = 0
            self.image.alpha = 0
        }
    }
}
