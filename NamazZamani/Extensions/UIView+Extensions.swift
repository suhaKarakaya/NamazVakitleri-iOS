//
//  UIView+Extensions.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 28.03.2022.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get{
            return cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    func setViewBorder(color: CGColor, borderWith: Int, borderRadius: Int){
        layer.borderColor = color
        layer.borderWidth = CGFloat(borderWith)
        layer.cornerRadius = CGFloat(borderRadius)
    }
    
    func setCircleView(color: CGColor, borderWith: Int, borderRadius: Int){
        layer.cornerRadius = CGFloat(borderRadius/2)
        clipsToBounds = true
        layer.borderColor = color
        layer.borderWidth = CGFloat(borderWith)
    }
    
    
}
