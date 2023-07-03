//
//  ProfilePhotosCell.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 02.07.2023.
//

import UIKit
import Kingfisher

class ProfilePhotosCell: UICollectionViewCell {
    
    private struct UIConstants {
        static let cornerRadius: CGFloat = 20
        static let fontSize: CGFloat = 40
        static let widthPadding: CGFloat = 20
        static let heightPadding: CGFloat = 15
    }
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = UIColor.AppColors.backgroundColor
        image.layer.masksToBounds = true
        return image
    }()
    
    
    // MARK: - override метод
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureCell() {
        backgroundColor = UIColor.AppColors.backgroundColor
        
        image.translatesAutoresizingMaskIntoConstraints = false
        addSubview(image)
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        image.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        image.layer.cornerRadius = bounds.width / 2
        image.backgroundColor = .lightGray
    }
    
    func fillImageWith(url: URL?, completion: @escaping (UIImage) -> ()) {
        image.kf.setImage(with: url) { result in
            switch result {
            case .success(_):
                completion(self.image.image!)
            case .failure(_):
                completion(UIImage(named: "captainRex")!)
            }
        }
    }
    func fillImageWith(icon: UIImage) {
        image.image = icon
    }
    
    func getCurrentImage() -> UIImage {
        return image.image ?? UIImage(named: "captainRex")!
    }
}

