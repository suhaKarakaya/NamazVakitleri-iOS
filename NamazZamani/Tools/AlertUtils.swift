//
//  AlertUtils.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 31.12.2022.
//

import Foundation
import UIKit

func showOneButtonAlert(title: String, message: String, buttonTitle: String, view: UIViewController, completion: @escaping (Bool) -> Void){
    
    let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let okButton = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { UIAlertAction in
        completion(true)
    })
    okButton.setValue(UIColor(named: "kabeYellow"), forKey: "titleTextColor")
    alert.addAction(okButton)
    
    view.present(alert, animated: true, completion: nil)
}

func showTwoButtonAlert(title: String, message: String, button1Title: String, button2Title: String, view: UIViewController, completion: @escaping (Bool) -> Void){
    let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let acceptButton = UIAlertAction(title: button1Title, style: UIAlertAction.Style.default, handler: { UIAlertAction in
        completion(true)
    })
    acceptButton.setValue(UIColor(named: "kabeYellow"), forKey: "titleTextColor")
    alert.addAction(acceptButton)
    
    let cancelButton = UIAlertAction(title: button2Title, style: UIAlertAction.Style.default, handler: { UIAlertAction in
        completion(false)
    })
    cancelButton.setValue(UIColor(named: "kabeYellow"), forKey: "titleTextColor")
    alert.addAction(cancelButton)
    
    view.present(alert, animated: true, completion: nil)
    
    
    
    
}
extension UIAlertController {
    
    //Set background color of UIAlertController
    func setBackgroundColor(color: UIColor) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = color
        }
    }
    
    //Set title font and title color
    func setTitlet(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, title.utf8.count))
        }
        
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : titleColor],//3
                                          range: NSMakeRange(0, title.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")//4
    }
    
    //Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : messageFont],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : messageColorColor],
                                          range: NSMakeRange(0, message.utf8.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    
    //Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
}

/*
 
 //
 //  AlertUtils.swift
 //  NamazVakitleri
 //
 //  Created by Süha Karakaya on 31.12.2022.
 //
 
 import Foundation
 import UIKit
 
 protocol AlertShowable {
 func showOneButtonAlert(title: String, message: String, buttonTitle: String)
 func showOneButtonConfirmAlert(title: String, message: String, buttonTitle: String, completion: @escaping () -> ())
 func showTwoButtonAlert(title: String, message: String, button1Title: String, button2Title: String, completion: @escaping (Bool) -> ())
 }
 extension AlertShowable where Self: UIViewController {
 func showOneButtonAlert(title: String, message: String, buttonTitle: String) {
 let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
 let okButton = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { UIAlertAction in
 })
 okButton.setValue(UIColor(named: "kabeYellow"), forKey: "titleTextColor")
 alert.addAction(okButton)
 
 self.present(alert, animated: true, completion: nil)
 }
 
 func showOneButtonConfirmAlert(title: String, message: String, buttonTitle: String, completion: @escaping () -> ()) {
 let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
 let okButton = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { UIAlertAction in
 completion()
 })
 okButton.setValue(UIColor(named: "kabeYellow"), forKey: "titleTextColor")
 alert.addAction(okButton)
 
 self.present(alert, animated: true, completion: nil)
 }
 
 func showTwoButtonAlert(title: String, message: String, button1Title: String, button2Title: String, completion: @escaping (Bool) -> ()){
 let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
 let acceptButton = UIAlertAction(title: button1Title, style: UIAlertAction.Style.default, handler: { UIAlertAction in
 completion(true)
 })
 acceptButton.setValue(UIColor(named: "kabeYellow"), forKey: "titleTextColor")
 alert.addAction(acceptButton)
 
 let cancelButton = UIAlertAction(title: button2Title, style: UIAlertAction.Style.default, handler: { UIAlertAction in
 completion(false)
 })
 cancelButton.setValue(UIColor(named: "kabeYellow"), forKey: "titleTextColor")
 alert.addAction(cancelButton)
 
 self.present(alert, animated: true, completion: nil)
 }
 }
 
 
 
 
 
 
 */
