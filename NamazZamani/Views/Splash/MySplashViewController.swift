//
//  MySplashViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 3.03.2022.
//

import UIKit
import Firebase

class MySplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(2)
        FirebaseClient.getDocWhereCondt("UserInfo", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
            if result {
                self.performSegue(withIdentifier: "sg_toHome", sender: nil)
                
            } else {
                
                self.performSegue(withIdentifier: "sg_toLocationSelect", sender: false)
                
                
            }
            
        }
        
    }
    
    
}
