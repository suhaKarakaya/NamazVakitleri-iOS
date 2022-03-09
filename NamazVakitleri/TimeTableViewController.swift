//
//  TimeTableViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 5.03.2022.
//

import UIKit
import Firebase
import ObjectMapper

class TimeTableViewController: UIViewController {
    
    

    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var loc:String = ""
    var tempDicsList: [[String:Any]] = [[:]]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(Picker.self, forCellReuseIdentifier: "timeTableCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let firestore = Firestore.firestore()
        let docRef = firestore.collection("Home").document(FirstSelectViewController.deviceId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let myLocation = Mapper<Home>().map(JSON: document.data() ?? ["":""]) else { return }
                myLocation.toJSON()
                for item in myLocation.favoriteList {
                    if item.isFavorite {
                        self.loc = item.location["location"] as? String ?? ""
                        self.labelLocation.text = item.location["location"] as? String ?? ""
                    }
                }
                
                let docRef = firestore.collection("Locations").document(self.loc)
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        guard let myLocation = Mapper<Locations>().map(JSON: document.data() ?? ["":""]) else { return }
                        myLocation.toJSON()
                        self.tempDicsList = myLocation.locationList
                        self.tableView.reloadData()
            } else {
                
            }
        }
                
            }
            
        }
        
    }
}

extension TimeTableViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempDicsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableCell", for: indexPath) as! TimeViewCell
        
        var tempDics:[String:Any] = self.tempDicsList[indexPath.row]
        
        cell.labelMiladiTarihValue.text = tempDics["MiladiTarihUzun"] as? String ?? ""
        cell.labelHicriTarihValue.text = tempDics["HicriTarihUzun"] as? String ?? ""
        cell.labelImsakValue.text = tempDics["Imsak"] as? String ?? ""
        cell.labelGunesValue.text = tempDics["Gunes"] as? String ?? ""
        cell.labelOgleValue.text = tempDics["Ogle"] as? String ?? ""
        cell.labelIkindiValue.text = tempDics["Ikindi"] as? String ?? ""
        cell.labelAksamValue.text = tempDics["Aksam"] as? String ?? ""
        cell.labelYatsiValue.text = tempDics["Yatsi"] as? String ?? ""
        
        return cell

    
    }
    

    
    
}
