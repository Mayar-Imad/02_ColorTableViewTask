//
//  CustomTextField.swift
//  02_ColorTableViewTask
//
//  Created by FTS on 06/09/2023.
//

import UIKit

class CustomTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureBorder()
    }
    
    private func configureBorder() {
        layer.cornerRadius = bounds.height / 2
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        //layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
}
