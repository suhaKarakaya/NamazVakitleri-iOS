//
//  SettingsViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 7.03.2022.
//

import UIKit
import Firebase
import ObjectMapper

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var vakitList: [FavoriteLocations] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let data = sender as? Bool {
            let view = segue.destination as! FirstSelectViewController
            view.backVisible = data
        }
    }
    
    @IBAction func buttonSelectedAction(_ sender: Any) {
        performSegue(withIdentifier: "sg_toSelected", sender: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vakitList = []
        let firestore = Firestore.firestore()
        let docRef = firestore.collection("Home").document(FirstSelectViewController.deviceId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let myLocation = Mapper<Home>().map(JSON: document.data() ?? ["":""]) else { return }
                myLocation.toJSON()
                for item in myLocation.favoriteList {
                    self.vakitList.append(item as! FavoriteLocations)
                }
                self.tableView.reloadData()
            }
        }
        
    }
    
    func setFavo(isSelected: Bool){
        self.tableView.reloadData()
    }
    
}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vakitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsViewCell
        
        cell.delegate = self
        cell.favoritedHandler = setFavo
        cell.data = vakitList[indexPath.row]
    
        
        return cell
    
    }
}

extension SettingsViewController: SettingsDelegate {
    func setFavorite(_ selected: Bool) {
        self.tableView.reloadData()
    }
    
    func toTrash(_ selected: Bool) {
        
    }
    
    
}

