//
//  File.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 16.02.2022.
//

import Foundation
import UIKit

protocol PickerDelegate: class{
    func clicked(type: PickerType);
    
}

class Picker: UIView {
    
    @IBOutlet weak var selectTitleLabel: UILabel!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var selectLabel: UILabel!
    var type:PickerType = .country
    
    weak var delegate: PickerDelegate?
    
    class func instance() -> Picker {
            guard let view = UINib(
                nibName: String(describing: self), bundle: nil
            ).instantiate(withOwner: nil, options: nil).first as? Picker else {
                fatalError("Could not initalize view")
            }
            view.mysetup()
            return view
        }
    
    func mysetup(){
        borderView.setViewBorder(color:  UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
    }
    
    @IBAction func selectedAction(_ sender: Any) {
        delegate?.clicked(type: self.type)
    }
    
}
