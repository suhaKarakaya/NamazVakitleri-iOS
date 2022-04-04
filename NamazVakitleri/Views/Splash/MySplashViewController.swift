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
        FirebaseClient.getDocWhereCondt("UserDevice", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
            if result {
                self.performSegue(withIdentifier: "sg_toHome", sender: nil)
            } else {
                let tempObj = UserDevice()
                tempObj.deviceId = FirstSelectViewController.deviceId
                tempObj.deviceType = "iOS"
                FirebaseClient.setAllData("UserDevice", tempObj.toJSON()) { result, documentID in
                    if result {
                        self.performSegue(withIdentifier: "sg_toLocationSelect", sender: false)
                    }
                }
                
            }
            
        }
    
    }
    

}
