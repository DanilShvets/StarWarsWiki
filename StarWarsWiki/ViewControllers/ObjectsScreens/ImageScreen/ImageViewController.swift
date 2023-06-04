//
//  ImageViewController.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 04.06.2023.
//

import UIKit

final class ImageViewController: UIViewController {
    
    init(topAreaHeight: CGFloat, navigationBarHeight: CGFloat, image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        let imageWindowView = ImageWindowView(topAreaHeight: topAreaHeight, navigationBarHeight: navigationBarHeight, image: image)
        imageWindowView.delegate = self
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        view = imageWindowView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.hidesBackButton = false
        view.backgroundColor = .systemIndigo
        
    }
}

extension ImageViewController: ImageWindowViewDelegate {
    func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    
}
