//
//  HomeViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 5.03.2022.
//

import UIKit
import Firebase
import ObjectMapper

class HomeViewController: UIViewController {
    @IBOutlet weak var labelYatsiValue: UILabel!
    @IBOutlet weak var labelAksamValue: UILabel!
    @IBOutlet weak var labelIkindiValue: UILabel!
    @IBOutlet weak var labelOgleValue: UILabel!
    @IBOutlet weak var labelGunesValue: UILabel!
    @IBOutlet weak var labelImsakValue: UILabel!
    @IBOutlet weak var labelYatsiKey: UILabel!
    @IBOutlet weak var labelAksamKey: UILabel!
    @IBOutlet weak var labelIkindiKey: UILabel!
    @IBOutlet weak var labelOgleKey: UILabel!
    @IBOutlet weak var labelGunesKey: UILabel!
    @IBOutlet weak var labelImsakKey: UILabel!
    @IBOutlet weak var labelKalanSureValue: UILabel!
    @IBOutlet weak var labelKalanSure: UILabel!
    @IBOutlet weak var labelHicriTarih: UILabel!
    @IBOutlet weak var labelMiladiTarih: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var viewTime: UIStackView!
    var loc:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewTime.layer.borderColor = UIColor.systemBrown.cgColor
        viewTime.layer.borderWidth = 1
        viewTime.layer.cornerRadius = 8
        
        let firestore = Firestore.firestore()
        let docRef = firestore.collection("Home").document(FirstSelectViewController.deviceId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let myLocation = Mapper<Home>().map(JSON: document.data() ?? ["":""]) else { return }
                myLocation.toJSON()
                for item in myLocation.favoriteList {
                    if item.isFavorite {
                        self.loc = item.location["location"] as? String ?? ""
                        self.labelLocation.text = self.loc
                    }
                }
                
                let docRef = firestore.collection("Locations").document(self.loc)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        guard let myLocation = Mapper<Locations>().map(JSON: document.data() ?? ["":""]) else { return }
                        myLocation.toJSON()
                        var tempDics:[String:Any] = [:]
                        tempDics = myLocation.locationList[0]
                        self.labelMiladiTarih.text = tempDics["MiladiTarihUzun"] as? String ?? ""
                        self.labelHicriTarih.text = tempDics["HicriTarihUzun"] as? String ?? ""
                        self.labelImsakValue.text = tempDics["Imsak"] as? String ?? ""
                        self.labelGunesValue.text = tempDics["Gunes"] as? String ?? ""
                        self.labelOgleValue.text = tempDics["Ogle"] as? String ?? ""
                        self.labelIkindiValue.text = tempDics["Ikindi"] as? String ?? ""
                        self.labelAksamValue.text = tempDics["Aksam"] as? String ?? ""
                        self.labelYatsiValue.text = tempDics["Yatsi"] as? String ?? ""
                
                
      
            } else {
                
            }
        }

        
    }
    


}
    }}
