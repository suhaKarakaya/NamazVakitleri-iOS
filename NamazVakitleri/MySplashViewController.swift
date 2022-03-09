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
        let firestore = Firestore.firestore()
        let docRef = firestore.collection("Home").document(FirstSelectViewController.deviceId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.performSegue(withIdentifier: "sg_toHome", sender: nil)
            } else {
                self.performSegue(withIdentifier: "sg_toLocationSelect", sender: false)
            }
        }
    }
    



}
