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
//    var saveData = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        
    }
    
    func getData(){
//        FirebaseClient.getDocRefData("User", FirstSelectViewController.deviceId) { result, documentId, response in
//            if result {
//                guard let myLocation = Mapper<User>().map(JSON: response) else { return }
//                self.saveData = myLocation
//                self.tableView.reloadData()
//            }
//        }
    }
    
    
//    func setData(saveData: User){
//
//        FirebaseClient.setDocRefData(FirstSelectViewController.deviceId, "User", saveData.toJSON()) { flag, statu in
//            guard flag else { return }
//            if flag {
//                self.getData()
//            }
//        }
//
//    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sg_toSelected" {
            if let data = sender as? Bool {
                let view = segue.destination as! FirstSelectViewController
                view.backVisible = data
//                view.saveData = self.saveData
            }
        }
        
       
    }
    
    @IBAction func buttonSelectedAction(_ sender: Any) {
//        if self.saveData.locations.count < 3 {
//            performSegue(withIdentifier: "sg_toSelected", sender: true)
//        } else {
//            let alert = UIAlertController.init(title: "Uyarı", message: "En fala 3 adet konum ekleyebilirsiniz!", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
//                
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
        
    }
    
    
   
    
    func setFavo(isSelected: Bool, index: Int){
//        if self.saveData.locations.count < 2 {
//            if isSelected {
//                let alert = UIAlertController.init(title: "Uyarı", message: "En fala 1 adet favori konum bulunmalıdır!", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
//
//                }))
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                self.saveData.locations[index].isFavorite = !isSelected
//                setData(saveData: self.saveData)
//            }
//        } else {
//            if !isSelected {
//                for item in self.saveData.locations {
//                    item.isFavorite = false
//                }
//                self.saveData.locations[index].isFavorite = !isSelected
//                setData(saveData: self.saveData)
//            }
//
//        }
        
        
    }
    
}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
//        saveData.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsViewCell
        
        cell.delegate = self
        cell.favoritedHandler = setFavo
//        cell.data = saveData.locations[indexPath.row]
        cell.index = indexPath.row
    
        
        return cell
    
    }
}

extension SettingsViewController: SettingsDelegate {
    func setFavorite(_ selected: Bool, _ index: Int) {

    }
    
    func toTrash(_ selected: Bool, _ index: Int) {
//        if self.saveData.locations.count < 2 {
//            let alert = UIAlertController.init(title: "Uyarı", message: "En fala 1 adet favori konum bulunmalıdır!", preferredStyle:
//                                                    UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
//
//            }))
//            self.present(alert, animated: true, completion: nil)
//        } else {
//            if self.saveData.locations[index].isFavorite {
//                let alert = UIAlertController.init(title: "Uyarı", message: "Favori konum silemezsiniz!", preferredStyle:
//                                                        UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
//
//                }))
//                self.present(alert, animated: true, completion: nil)
//            } else {
//                self.saveData.locations.remove(at: index)
//                if self.saveData.locations.count == 1 {
//                    self.saveData.locations[0].isFavorite = true
//                }
//                setData(saveData: self.saveData)
//            }
//
//        }
        
      
    }
    
   
    
    
}

