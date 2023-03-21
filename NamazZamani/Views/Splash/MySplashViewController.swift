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
        let savedArray = UserDefaults.standard.object(forKey: "savedLocationInfo") as? [String] ?? [String]()
        if savedArray.isEmpty {
            self.performSegue(withIdentifier: "sg_toSelectedPage", sender: nil)
        } else {
            PrayerTimeOrganize.getMyLocationData { data, result in
                if result {
//                    do {
//                        // Create JSON Encoder
//                        let encoder = JSONEncoder()
//
//                        // Encode Note
//                        let _data = try encoder.encode(data)
//
//                        // Write/Set Data
//                        UserDefaults.standard.set(_data, forKey: "vakit")
//
//                    } catch {
//                        print("Unable to Encode Note (\(error))")
//                    }
                    self.performSegue(withIdentifier: "sg_toTabPage", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "sg_toSelectedPage", sender: nil)
                }
            }
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "sg_toTabPage" {
//            guard let data = sender as? LocationDetail, let destinationNavigationController = segue.destination as? UITabBarController else {return}
//            let targetController = destinationNavigationController.selectedViewController as? HomeViewController
//            targetController?.locationData = data
//
//
//
//
//        }
//    }
    
    
}
