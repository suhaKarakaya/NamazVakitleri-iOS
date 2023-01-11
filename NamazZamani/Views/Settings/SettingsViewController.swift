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
    var locationList: [UserInfo] = []
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
        FirebaseClient.getDocWhereCondt("UserInfo", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
            if result {
                LoadingIndicatorView.hide()
                self.documentIdList = []
                self.locationList = []
                for item in response {
                    guard let myLocation = Mapper<UserInfo>().map(JSON: item.document) else { return }
                    let obj:UserInfo = myLocation
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
            FirebaseClient.setDocRefData(item.documentId, "UserInfo", item.userLocation.toJSON()) { result, status in
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
            showOneButtonAlert(title: "Uyarı", message: "En fazla 3 adet konum ekleyebilirsiniz!", buttonTitle: "Tamam", view: self) { confirm in
            }
        }
    }
    
    
   
    
    func setFavo(isSelected: Bool, index: Int){
        if self.locationList.count < 2 {
            if isSelected {
                showOneButtonAlert(title: "Uyarı", message: "En fazla 1 adet favori konum bulunmalıdır!", buttonTitle: "Tamam", view: self) { confirm in
                }
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
            showOneButtonAlert(title: "Uyarı", message: "En fazla 1 adet favori konum bulunmalıdır!", buttonTitle: "Tamam", view: self) { confirm in
            }
        } else {
            if self.locationList[index].isFavorite {
                showOneButtonAlert(title: "Uyarı", message: "Favori konum silemezsiniz!", buttonTitle: "Tamam", view: self) { confirm in
                }
            } else {
//                self.locationList.remove(at: index)
//                if self.locationList.count == 1 {
//                    self.locationList[0].isFavorite = true
//                }
                LoadingIndicatorView.show(self.view)
                FirebaseClient.delete("UserInfo", documentIdList[index].documentId) { result, status in
                    if result {
                        LoadingIndicatorView.hide()
                        showOneButtonAlert(title: "Bilgi", message: "İşleminiz başarılı bir şekilde gerçekleştirildi", buttonTitle: "Tamam", view: self) { confirm in
                            if confirm {
                                self.getData()
                            }
                        }
                    }
                }
            }

        }
        
      
    }
    
   
    
    
}

struct LocationList {
    var documentId: String = ""
    var userLocation: UserInfo = UserInfo()
    
    init(documentId: String, userLocation:UserInfo) {
        self.documentId = documentId
        self.userLocation = userLocation
    }
}

