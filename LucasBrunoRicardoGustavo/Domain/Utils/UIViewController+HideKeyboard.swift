//
//  UIViewController+HideKeyboard.swift
//  LucasBrunoRicardoGustavo
//
//  Created by Lucas Barcelos on 01/03/20.
//  Copyright © 2020 Lucas Barcelos. All rights reserved.
//

import Foundation
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
