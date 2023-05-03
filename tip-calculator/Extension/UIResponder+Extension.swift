//
//  UIResponder+Extension.swift
//  tip-calculator
//
//  Created by Sam Sung on 2023/05/03.
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
