//
//  CategoriesViewCell.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 07.04.2023.
//

import UIKit

class CategoriesViewCell: UICollectionViewCell {
    
    private struct UIConstants {
        static let cornerRadius: CGFloat = 20
        static let fontSize: CGFloat = 40
        static let widthPadding: CGFloat = 20
        static let heightPadding: CGFloat = 15
    }
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.backgroundColor = UIColor.AppColors.backgroundColor
        image.layer.cornerRadius = UIConstants.cornerRadius
        return image
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: UIConstants.fontSize)
        label.backgroundColor = .black.withAlphaComponent(0.6)
        label.layer.cornerRadius = UIConstants.cornerRadius
        label.layer.masksToBounds = true
        return label
    }()
    
    
    // MARK: - override метод
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        animateCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureCell() {
        backgroundColor = UIColor.AppColors.backgroundColor
        
        addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        image.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        image.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        image.clipsToBounds = true
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func fillLabelWith(data: String) {
        self.label.text = data
    }
    
    func fillImageWith(imageName: String) {
        self.image.image = UIImage(named: imageName)
    }
    
    private func animateCell() {
        image.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.image.alpha = 1
        }
    }
    
}
