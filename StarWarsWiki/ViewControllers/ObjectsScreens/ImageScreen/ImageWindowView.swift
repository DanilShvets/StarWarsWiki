//
//  ImageWindowView.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 04.06.2023.
//

import UIKit

protocol ImageWindowViewDelegate: AnyObject {
    func cancelButtonPressed()
}

class ImageWindowView: UIView {
    
    struct UIConstants {
        static let cancelButtonSize: CGFloat = 30
        static let cancelButtonPadding: CGFloat = 15
    }
    
    private lazy var popupView = UIView(frame: CGRect.zero)
    private lazy var popupTopArea = UILabel(frame: CGRect.zero)
    private lazy var containerView = UIView(frame: CGRect.zero)
    private lazy var popupImageView = UIImageView(frame: CGRect.zero)
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    weak var delegate: ImageWindowViewDelegate?
    
    init(topAreaHeight: CGFloat, navigationBarHeight: CGFloat, image: UIImage) {
        
        super.init(frame: CGRect.zero)
        addRecognizers()
        
        popupView.backgroundColor = .black
        addSubview(popupView)
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        popupView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        popupView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        popupView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        popupView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: popupView.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: popupView.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: popupView.heightAnchor).isActive = true
        
        containerView.addSubview(popupImageView)
        popupImageView.image = image
        popupImageView.isUserInteractionEnabled = true
        popupImageView.contentMode = .scaleAspectFit
        popupImageView.translatesAutoresizingMaskIntoConstraints = false
        popupImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        popupImageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        popupImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        popupImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        popupTopArea.backgroundColor = UIColor.AppColors.darkGray
        popupView.addSubview(popupTopArea)
        popupTopArea.translatesAutoresizingMaskIntoConstraints = false
        popupTopArea.topAnchor.constraint(equalTo: popupView.topAnchor).isActive = true
        popupTopArea.leadingAnchor.constraint(equalTo: popupView.leadingAnchor).isActive = true
        popupTopArea.trailingAnchor.constraint(equalTo: popupView.trailingAnchor).isActive = true
        popupTopArea.heightAnchor.constraint(equalToConstant: topAreaHeight).isActive = true
        
        popupView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: popupView.topAnchor, constant: (topAreaHeight + topAreaHeight - navigationBarHeight) / 2 - UIConstants.cancelButtonSize / 2).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: popupTopArea.trailingAnchor, constant: -UIConstants.cancelButtonPadding).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: UIConstants.cancelButtonSize).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: UIConstants.cancelButtonSize).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addRecognizers() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        [pinchGesture, panGesture].forEach {
            $0.delegate = self
            popupImageView.addGestureRecognizer($0)
        }
    }
    
    @objc func cancelButtonPressed() {
        delegate?.cancelButtonPressed()
    }
    
    @objc func handlePinch(gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.state == .began || gestureRecognizer.state == .changed || gestureRecognizer.state == .ended else {return}
        gestureRecognizer.view?.transform = gestureRecognizer.view?.transform.scaledBy(x: gestureRecognizer.scale, y: gestureRecognizer.scale) ?? .identity
        
        if gestureRecognizer.state == .ended {
            UIView.animate(withDuration: 0.3) {
                gestureRecognizer.view?.transform = .identity
            }
        }
        gestureRecognizer.scale = 1
    }
    
    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        gestureRecognizer.view?.center.x += translation.x
        gestureRecognizer.view?.center.y += translation.y
        gestureRecognizer.setTranslation(.zero, in: gestureRecognizer.view)
        if gestureRecognizer.state == .ended {
            UIView.animate(withDuration: 0.3) {
                gestureRecognizer.view?.transform = .identity
                gestureRecognizer.view?.frame = self.bounds
            }
        }
    }
}

extension ImageWindowView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
