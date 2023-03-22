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
        //        sleep(2)
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        PrayerTimeOrganize.getMyLocationData { data, result in
            if result {
                self.performSegue(withIdentifier: "sg_toTabPage", sender: nil)
            } else {
                self.performSegue(withIdentifier: "sg_toSelectedPage", sender: nil)
            }
        }
    }
    
    
}
