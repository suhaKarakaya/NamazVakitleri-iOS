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
    var locationList: [UserLocations] = []
    var documentIdList: [LocationList] = []
    
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
        LoadingIndicatorView.show(self.view)
        FirebaseClient.getDocWhereCondt("UserLocations", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
            if result {
                LoadingIndicatorView.hide()
                self.documentIdList = []
                self.locationList = []
                for item in response {
                    guard let myLocation = Mapper<UserLocations>().map(JSON: item.document) else { return }
                    let obj:UserLocations = myLocation
                    self.locationList.append(obj)
                    self.documentIdList.append(LocationList.init(documentId: item.documentId, userLocation: obj))
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    func setData(_ documentList: [LocationList]){
        for item in documentList {
            LoadingIndicatorView.show(self.view)
            FirebaseClient.setDocRefData(item.documentId, "UserLocations", item.userLocation.toJSON()) { result, status in
                if result {
                    LoadingIndicatorView.hide()
                }
            }
        }
        getData()
     

    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sg_toSelected" {
            if let data = sender as? Bool {
                let view = segue.destination as! FirstSelectViewController
                view.backVisible = data
                view.documentIdList = documentIdList
            }
        }
        
       
    }
    
    @IBAction func buttonSelectedAction(_ sender: Any) {
        if self.locationList.count < 3 {
            performSegue(withIdentifier: "sg_toSelected", sender: true)
        } else {
            let alert = UIAlertController.init(title: "Uyarı", message: "En fala 3 adet konum ekleyebilirsiniz!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
   
    
    func setFavo(isSelected: Bool, index: Int){
        if self.locationList.count < 2 {
            if isSelected {
                let alert = UIAlertController.init(title: "Uyarı", message: "En fala 1 adet favori konum bulunmalıdır!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in

                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                for var item in documentIdList {
                    item.userLocation.isFavorite = false
                }
                documentIdList[index].userLocation.isFavorite = !isSelected
                setData(documentIdList)
            }
        } else {
            if !isSelected {
                for i in 0...documentIdList.count - 1 {
                    documentIdList[i].userLocation.isFavorite = false
                }
                documentIdList[index].userLocation.isFavorite = !isSelected
                setData(documentIdList)
            }

        }
        
        
    }
    
}

extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsViewCell
        
        cell.delegate = self
        cell.favoritedHandler = setFavo
        cell.data = locationList[indexPath.row]
        cell.index = indexPath.row
    
        
        return cell
    
    }
}

extension SettingsViewController: SettingsDelegate {
    func setFavorite(_ selected: Bool, _ index: Int) {

    }
    
    func toTrash(_ selected: Bool, _ index: Int) {
        if self.locationList.count < 2 {
            let alert = UIAlertController.init(title: "Uyarı", message: "En fala 1 adet favori konum bulunmalıdır!", preferredStyle:
                                                    UIAlertController.Style.alert)
            alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in

            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            if self.locationList[index].isFavorite {
                let alert = UIAlertController.init(title: "Uyarı", message: "Favori konum silemezsiniz!", preferredStyle:
                                                        UIAlertController.Style.alert)
                alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in

                }))
                self.present(alert, animated: true, completion: nil)
            } else {
//                self.locationList.remove(at: index)
//                if self.locationList.count == 1 {
//                    self.locationList[0].isFavorite = true
//                }
                LoadingIndicatorView.show(self.view)
                FirebaseClient.delete("UserLocations", documentIdList[index].documentId) { result, status in
                    if result {
                        LoadingIndicatorView.hide()
                        let alert = UIAlertController.init(title: "Bilgi", message: "İşleminiz başarılı bir şekilde gerçekleştirildi", preferredStyle:
                                                                UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
                            self.getData()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }

        }
        
      
    }
    
   
    
    
}

struct LocationList {
    var documentId: String = ""
    var userLocation: UserLocations = UserLocations()
    
    init(documentId: String, userLocation:UserLocations) {
        self.documentId = documentId
        self.userLocation = userLocation
    }
}

