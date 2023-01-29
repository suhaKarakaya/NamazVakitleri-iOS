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
    @IBOutlet weak var lblTitle: UILabel!
    var userZikrList: [ZikirObj]?
    var selectedZikr: ZikirObj? {
        didSet {
            if let m = selectedZikr {
                self.selectedZikirLabel.text = self.selectedZikr?.data.zikir
                self.counterZikirLabel.text = String(self.selectedZikr?.data.count ?? 0)
            } else {
                self.selectedZikirLabel.text = ""
                self.counterZikirLabel.text = "Başla"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterZikirView.setCircleView(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: Int(counterZikirView.frame.size.width))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblTitle.text = "Zikirmatik"
        getData()
    }

    func getData(){
        LoadingIndicatorView.show(self.view)
            FirebaseClient.getDocWhereCondt("UserZikr", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
                LoadingIndicatorView.hide()
                if result {
    //                kullanıcının içeride daha önceden seçmiş olduğu zikr var demek
                    self.userZikrList = []
                    for item in response {
                        guard let tempObj = Mapper<Zikir>().map(JSON:  item.document) else { return }
                        let zikr = ZikirObj()
                        zikr.id = item.documentId
                        zikr.data = tempObj
                        self.userZikrList?.append(zikr)
                    }
                    for item in self.userZikrList ?? [] {
                        if item.data.isSelected {
                            self.selectedZikr = item
                            return
                        } else {
                            self.selectedZikr = nil
                        }
                    }
                } else {
    //                kullanıcının içeride daha önce seçmiş olduğu zikr yok
                    self.selectedZikr = nil
                }
                
            }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setSelectedZikir(_selectedZikr: selectedZikr) {
            
        }
    }

    func setMemory(data: Zikir){
        let defaults = UserDefaults.init()
        defaults.set(data.toJSON(), forKey: "userZikirModel")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sg_toZikirSec" {
            let view = segue.destination as! ZikirSecViewController
            if let data = sender as? ZikirObj {
                view.selectedZikr = data
            }
            view.handler = selectedHandler
        } else if segue.identifier == "sg_toKayitliZikir" {
            let view = segue.destination as! KayitliZikirViewController
            if let data = sender as? ZikirObj {
                view.selectedZikr = data
            }
            view.handler = selectedHandler
        } else if segue.identifier == "sg_toZikirOlustur" {
            let view = segue.destination as! ZikirOlusturViewController
            if let data = sender as? ZikirObj {
                view.selectedZikr = data
            }
            view.handler = selectedHandler
        }
    }
    
    func selectedHandler(flag: Bool) {
        if flag {
//            gidilip geri gelinen sayfalarda işlem yapılmış demektir
            getData()
        }
    }
    
    func setSelectedZikir(_selectedZikr: ZikirObj?, completion: @escaping () -> Void) {
        if let tempData = _selectedZikr {
            FirebaseClient.setDocRefData(tempData.id, "UserZikr", tempData.data.toJSON()) { result, status in
                if result {
                    completion()
                } else {
    //                bir problem çıktı alerti
                }
            }
        } else {
            completion()
        }
    }
    
    @IBAction func zikirOlusturButtonAction(_ sender: Any) {
        setSelectedZikir(_selectedZikr: selectedZikr) {
            self.performSegue(withIdentifier: "sg_toZikirOlustur", sender: self.selectedZikr)
        }
    }
    @IBAction func kayitliZikirlerimButtonAction(_ sender: Any) {
        setSelectedZikir(_selectedZikr: selectedZikr) {
            self.performSegue(withIdentifier: "sg_toKayitliZikir", sender: self.selectedZikr)
        }
    }
    
    @IBAction func zikirSecButtonAction(_ sender: Any) {
        setSelectedZikir(_selectedZikr: selectedZikr) {
            self.performSegue(withIdentifier: "sg_toZikirSec", sender: self.selectedZikr)
        }
    }
    
    @IBAction func counterZikirButtonAction(_ sender: Any) {
        if selectedZikr != nil {
            selectedZikr?.data.count += 1
            self.counterZikirLabel.text = String(selectedZikr?.data.count ?? 0)
        } else {
            showOneButtonAlert(title: "Uyarı", message: "Seçilmiş zikiriniz bulunmamaktadır!", buttonTitle: "Tamam", view: self) { confirm in
            }
        }
    }
    
}
