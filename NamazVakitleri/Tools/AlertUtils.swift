//
//  AlertUtils.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 31.12.2022.
//

import Foundation
import UIKit

func showOneButtonAlert(title: String, message: String, buttonTitle: String, view: UIViewController, completion: @escaping (Bool) -> Void){
    let attributedString = NSAttributedString(string: title, attributes: [
        NSAttributedString.Key.font : UIFont(name: "Future", size: 15),
        NSAttributedString.Key.foregroundColor : UIColor(named: "kabeBlack")
    ])

    let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.setValue(attributedString, forKey: "attributedTitle")
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
