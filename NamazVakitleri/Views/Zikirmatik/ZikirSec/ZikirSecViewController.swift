//
//  ZikirSecViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 30.03.2022.
//

import UIKit
import Firebase
import ObjectMapper


class ZikirSecViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var zikirList: [Zikir] = []
    var documentID = ""
    weak var delegate: ZikirSecDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData(){
        self.zikirList = []
        let firestore = Firestore.firestore()
        
        FirebaseClient.getAllData("Zikir") { flag, documentID, response in
            if flag {
                self.documentID = documentID
                guard let myList = Mapper<ZikirListModel>().map(JSON: response) else { return }
                myList.toJSON()
                self.zikirList = myList.zikirList
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    func setInfo(zikir: String, aciklama: String){
        let alert = UIAlertController.init(title: zikir, message: aciklama, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func toTrash(index: Int){
        let alert = UIAlertController.init(title: "Uyarı", message: "Seçmiş olduğunuz zikiri silmek istediğinizden emin misiniz?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Evet", style: UIAlertAction.Style.default, handler: { UIAlertAction in
            self.zikirList.remove(at: index)
            
            var zikirModel = ZikirListModel()
            zikirModel.zikirList = self.zikirList
            
            FirebaseClient.setDocRefData(self.documentID, "Zikir", zikirModel.toJSON()) { flag, statu in
                guard flag else { return }
                if flag {
                    self.getData()
                }
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Hayır", style: UIAlertAction.Style.default, handler: { UIAlertAction in
            
         
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectZikir(data: Zikir){
        var selectZikir = SelectZikir()
        selectZikir.id = data.id
        selectZikir.count = 0
        selectZikir.isSelected = true
        selectZikir.zikir = data.zikir
        
        FirebaseClient.getDocRefData("User", FirstSelectViewController.deviceId) { flag, documentId, response in
            if flag {
                guard let myLocation = Mapper<User>().map(JSON: response) else { return }
                for item in myLocation.saveZikirList {
                    item.isSelected = false
                }
                myLocation.saveZikirList.append(selectZikir)
                FirebaseClient.setDocRefData(FirstSelectViewController.deviceId, "User", myLocation.toJSON()) { flag, statu in
                    guard flag else { return }
                    if flag {
                        self.delegate?.selected()
                        self.dismiss(animated: true)
                    }
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
        cell.index = indexPath.row
        cell.infoHandler = self.setInfo
        cell.trashHandler = self.toTrash
        cell.selectHandler = self.selectZikir
        
        return cell

    
    }
    
    
}
