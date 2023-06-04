//
//  InfoViewController.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 04.06.2023.
//

import UIKit

final class InfoViewController: UIViewController {
    
    private var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = UIColor.AppColors.textColor
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.AppColors.backgroundColor
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 5).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        label.text = "You can browse and zoom image on full screen. Just tap on it."
    }
}
