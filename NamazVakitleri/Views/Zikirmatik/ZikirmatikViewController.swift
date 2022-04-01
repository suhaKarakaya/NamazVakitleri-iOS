//
//  ZikirmatikViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 30.03.2022.
//

import UIKit
import Firebase
import ObjectMapper

class ZikirmatikViewController: UIViewController {
    @IBOutlet weak var counterZikirView: UIView!
    @IBOutlet weak var counterZikirLabel: UILabel!
    @IBOutlet weak var selectedZikirLabel: UILabel!
    var userData = SelectZikir()
    var userDataList: [SelectZikir] = []
    var userMainData = User()
    var myCount = 0
    var documentId = ""
    var countFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counterZikirView.setCircleView(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: Int(counterZikirView.frame.size.width))

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        
    }

    
    func getData(){
        FirebaseClient.getDocRefData("User", FirstSelectViewController.deviceId) { flag, documentId, response in
            if flag {
                guard let myLocation = Mapper<User>().map(JSON: response) else { return }
                self.userMainData = myLocation
                self.documentId = documentId
                self.userDataList = []
                self.userDataList = myLocation.saveZikirList
                self.countFlag = true
                if myLocation.saveZikirList.count == 0 {
                    self.selectedZikirLabel.text = ""
                    self.counterZikirLabel.text = "Başla"
                } else {
                    for item in myLocation.saveZikirList {
                        if item.isSelected {
                            self.countFlag = false
                            self.userData = item
                            self.myCount = Int(item.count)
                            self.selectedZikirLabel.text = item.zikir
                            self.counterZikirLabel.text = String(self.myCount)
                        }
                    }
                    if self.countFlag {
                        self.selectedZikirLabel.text = ""
                        self.counterZikirLabel.text = "Başla"
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        setMainData(data: userMainData)
    }
    
    func setMainData(data: User) {
        for item in userMainData.saveZikirList {
            if item.isSelected {
                item.count = Int64(myCount)
            }
        }
        FirebaseClient.setDocRefData(self.documentId, "User", data.toJSON()) { flag, statu in
            guard flag else { return }
            if flag {
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sg_toZikirSec" {
            let view = segue.destination as! ZikirSecViewController
            view.delegate = self
        } else if segue.identifier == "sg_toKayitliZikir" {
            let view = segue.destination as! KayitliZikirViewController
            view.delegate = self
        }
    }
    
    @IBAction func zikirOlusturButtonAction(_ sender: Any) {
        setMainData(data: userMainData)
        performSegue(withIdentifier: "sg_toZikirOlustur", sender: nil)
    }
    @IBAction func kayitliZikirlerimButtonAction(_ sender: Any) {
        setMainData(data: userMainData)
        performSegue(withIdentifier: "sg_toKayitliZikir", sender: nil)
    }
    
    @IBAction func zikirSecButtonAction(_ sender: Any) {
        setMainData(data: userMainData)
        performSegue(withIdentifier: "sg_toZikirSec", sender: nil)
    }
    
    @IBAction func counterZikirButtonAction(_ sender: Any) {
        if userDataList.count == 0 || countFlag {
            let alert = UIAlertController.init(title: "Uyarı", message: "Seçilmiş zikiriniz bulunmamaktadır!", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            myCount += 1
            self.counterZikirLabel.text = String(self.myCount)
            
        }
    }
    
}

extension ZikirmatikViewController: ZikirSecDelegate {
    func selected() {
        getData()
    }
    
    
}
