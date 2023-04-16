//
//  CharactersListViewCell.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 09.04.2023.
//

import UIKit

class ObjectsListViewCell: UITableViewCell {
    
    private struct UIConstants {
        static let fontSize: CGFloat = 20
    }
    
    static let cellId = "ObjectsListViewCell"
    
    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: UIConstants.fontSize)
        label.textColor = UIColor.AppColors.textColor
        return label
    }()
    
    
    // MARK: - override метод

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Конфигурация UI
    
    private func configureUI() {
        backgroundColor = UIColor.AppColors.backgroundColor
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func fillLabelWith(data: String) {
        self.label.text = data
    }
    
}
