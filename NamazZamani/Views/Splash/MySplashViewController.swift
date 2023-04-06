//
//  MySplashViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 3.03.2022.
//

import UIKit
import StoreKit


class MySplashViewController: UIViewController {
    
    static let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        FirebaseClient.getCurrentVersion { vs, build in
            if appVersion == vs {
                DispatchQueue.global(qos: .background).async {
                    PrayerTimeOrganize.getMyLocationData { data, result in
                        DispatchQueue.main.async {
                            if result {
                                self.performSegue(withIdentifier: "sg_toTabPage", sender: nil)
                            } else {
                                self.performSegue(withIdentifier: "sg_toSelectedPage", sender: nil)
                            }
                        }
                    }
                }
            } else {
                showOneButtonAlert(title: "Uyarı", message: "Uygulamanızın daha güncel bir versiyonu bulunmaktadır!", buttonTitle: "Tamam", view: self) { confirm in
                    if confirm { self.goStore() }
                }
                
            }
        }
    }
    
    private func goStore() {
        let testFlightAppURL = URL(string: "https://apps.apple.com/tr/app/namaz-zamanı/id1666369406")
        let testFlightProductID = 1666369406
        
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        // 3. Indicate a specific product by passing its iTunes item identifier
        let parameters = [SKStoreProductParameterITunesItemIdentifier: testFlightProductID]
        storeViewController.loadProduct(withParameters: parameters) { _, error in
            if error != nil {
                // In case there is an issue loading the product, open the URL directly
                UIApplication.shared.open(testFlightAppURL!)
            } else {
                self.present(storeViewController, animated: true)
            }
        }
    }
    
}

extension MySplashViewController: SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true)
    }
}

