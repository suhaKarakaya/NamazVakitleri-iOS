//
//  ZikirOlusturViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 30.03.2022.
//

import UIKit
import ObjectMapper

class ZikirOlusturViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textSuperView: UIView!
    var zikirList: [Zikir] = []
    var documentID = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        textSuperView.setViewBorder(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
        getData(false)
    }
    
    
    func getData(_ isExit: Bool){
        self.zikirList = []
        FirebaseClient.getAllData("Zikir") { flag, documentId, response in
            if flag {
                self.documentID = documentId
                guard let myList = Mapper<ZikirListModel>().map(JSON: response) else { return }
                self.zikirList = myList.zikirList
                if isExit {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        dismiss(animated: true)
    }

    @IBAction func saveButtonAction(_ sender: Any) {
        var tempZikir = Zikir()
        tempZikir.id = Int64(self.zikirList.count + 1)
        tempZikir.zikir = textView.text
        tempZikir.deletable = true
        tempZikir.kaynak = ""
        tempZikir.aciklamasi = ""
        self.zikirList.append(tempZikir)
        
        var zikirModel = ZikirListModel()
        zikirModel.zikirList = self.zikirList
        

        
        
        FirebaseClient.setDocRefData(documentID, "Zikir", zikirModel.toJSON()) { flag, statu in
            guard flag else { return }
            if flag {
                let alert = UIAlertController.init(title: "Bilgi", message: "Zikiriniz başarılı bir şekilde kaydedilmiştir.", preferredStyle: UIAlertController.Style.alert)
            
                alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
                    self.getData(true)
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
    
}
