//
//  FormTextField.swift
//  SignUpFormExample
//
//  Created by Yuriy Gudimov on 04.01.2023.
//

import UIKit

@IBDesignable
class FormTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
}
