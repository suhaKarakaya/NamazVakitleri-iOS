//
//  ZikirSecViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 30.03.2022.
//

import UIKit
import Firebase
import ObjectMapper

typealias ZikirSecSelected = (Bool) -> Void
class ZikirSecViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var zikirList: [ZikirObj] = []
    var selectedZikr: ZikirObj?
    public var handler: ZikirSecSelected? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDefaultsZikirList {
            self.getUserSavedZikirList()
        }
    }
    
    func getDefaultsZikirList(completion: @escaping () -> Void){
        FirebaseClient.getAllData("DefaultZikrs") { flag, documentID, response in
            if flag {
                self.zikirList = []
                guard let myList = Mapper<ZikirListModel>().map(JSON: response) else { return }
                for item in myList.zikirList {
                    let temp = ZikirObj()
                    temp.id = ""
                    temp.data = item
                    self.zikirList.append(temp)
                }
                completion()
            }
        }
    }
    
    func getUserSavedZikirList(){
        FirebaseClient.getDocWhereCondt("UserCustomZikir", "deviceId", FirstSelectViewController.deviceId) {
            result, status, _response in
            if result {
                for item in _response {
                    guard let myZikir = Mapper<Zikir>().map(JSON: item.document) else { return }
                    let temp = ZikirObj()
                    temp.id = item.documentId
                    temp.data = myZikir
                    self.zikirList.append(temp)
                }
                self.tableView.reloadData()
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func setInfo(data: ZikirObj){
        let alert = UIAlertController.init(title: data.data.zikir, message: String(format: "%@\n%@%@", data.data.aciklamasi,"Kaynak: ", data.data.kaynak), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func toTrash(data: ZikirObj){
        let alert = UIAlertController.init(title: "Uyarı", message: "Seçmiş olduğunuz zikiri silmek istediğinizden emin misiniz?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Evet", style: UIAlertAction.Style.default, handler: { UIAlertAction in
            FirebaseClient.delete("UserCustomZikir", data.id){ flag, statu in
                guard flag else { return }
                if flag {
                    self.getDefaultsZikirList{
                        self.getUserSavedZikirList()
                    }
                }
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Hayır", style: UIAlertAction.Style.default, handler: { UIAlertAction in
     
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setOtherZikr(completion: @escaping () -> Void) {
        if selectedZikr != nil {
            selectedZikr?.data.isSelected = false
            FirebaseClient.setDocRefData(selectedZikr?.id ?? "", "UserZikr", selectedZikr?.data.toJSON() ?? ["":""]) {
                result, status in
                if result {
                    completion()
                }
            }
        } else {
            completion()
        }
        
        
    }
    
    
    func selectZikir(data: ZikirObj){
        setOtherZikr {
            let tempZikr = data.data
            tempZikr.isSelected = true
            tempZikr.count = 0
            tempZikr.deviceId = FirstSelectViewController.deviceId
            FirebaseClient.setAllData("UserZikr", tempZikr.toJSON()) { result, id in
                if result {
                    let alert = UIAlertController.init(title: "Uyarı", message: "Zikir seçim başarılı", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
                        self.handler?(true)
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController.init(title: "Uyarı", message: "İşlem sırasında bir hata oluştur", preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
}

extension ZikirSecViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return zikirList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ZikirSecTableViewCell.identifier, for: indexPath) as! ZikirSecTableViewCell
        
        cell.setup(self.zikirList[indexPath.row])
        cell.infoHandler = self.setInfo
        cell.trashHandler = self.toTrash
        cell.selectHandler = self.selectZikir
        return cell
        
        
    }
    
    
}
