//
//  UIButtonExtension.swift
//  iOS-Calculator
//
//  Created by Carlos Morgado on 9/2/23.
//

import UIKit

extension UIButton {

// ROUNDED CORNER
    func round() {
        layer.cornerRadius = bounds.height / 2
        clipsToBounds = true
    }
    
// SHINE
    func shine() {
        UIView.animate(withDuration: 0.1, animations: {self.alpha = 0.5}) {(completion) in
        UIView.animate(withDuration: 0.1, animations: {self.alpha = 1})
        }
    }
}
