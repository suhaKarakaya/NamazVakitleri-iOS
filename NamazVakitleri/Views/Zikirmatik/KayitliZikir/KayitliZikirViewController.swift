//
//  KayitliZikirViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 30.03.2022.
//

import UIKit
import Firebase
import ObjectMapper

protocol ZikirSecDelegate: class {
    func selected()
}

class KayitliZikirViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
//    var userData = User()
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
//        FirebaseClient.getDocRefData("User", FirstSelectViewController.deviceId) { flag, documentId, response in
//            if flag {
//                guard let myLocation = Mapper<User>().map(JSON: response) else { return }
//                self.documentID = documentId
//                self.userData = myLocation
//                self.tableView.reloadData()
//            }
//        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.delegate?.selected()
        dismiss(animated: true)
    }
    
    
    func toTrash(index: Int){
        let alert = UIAlertController.init(title: "Uyarı", message: "Seçmiş olduğunuz zikiri silmek istediğinizden emin misiniz?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Evet", style: UIAlertAction.Style.default, handler: { UIAlertAction in
//            self.userData.saveZikirList.remove(at: index)
//
//            FirebaseClient.setDocRefData(self.documentID, "User", self.userData.toJSON()) { flag, statu in
//                guard flag else { return }
//                if flag {
//                    self.getData()
//                }
//            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Hayır", style: UIAlertAction.Style.default, handler: { UIAlertAction in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func selectZikir(index: Int){
//        for item in self.userData.saveZikirList {
//            item.isSelected = false
//        }
//        self.userData.saveZikirList[index].isSelected = true
//
//        FirebaseClient.setDocRefData(self.documentID, "User", self.userData.toJSON()) { flag, statu in
//            guard flag else { return }
//            if flag {
//                self.delegate?.selected()
//                self.dismiss(animated: true)
//            }
//        }
        
    }

}

extension KayitliZikirViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
//        userData.saveZikirList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: KayitliZikirTableViewCell.identifier, for: indexPath) as! KayitliZikirTableViewCell
        
//        cell.setup(self.userData.saveZikirList[indexPath.row])
        cell.index = indexPath.row
        cell.trashHandler = self.toTrash
        cell.selectHandler = self.selectZikir

        
        return cell

    
    }
    
    
}
