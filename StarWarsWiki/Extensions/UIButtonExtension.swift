//
//  UIButtonExtension.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 02.07.2023.
//

import UIKit

extension UIButton {
    func loadingIndicator(show: Bool) {
        let tag = 66
        if show {
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPointMake(buttonWidth/2, buttonHeight/2)
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
