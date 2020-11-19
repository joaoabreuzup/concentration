//
//  UIViewControllerExtension.swift
//  Concentration
//
//  Created by João Jacó Santos Abreu on 30/01/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
