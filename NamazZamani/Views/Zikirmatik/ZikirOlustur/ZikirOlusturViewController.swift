//
//  ZikirOlusturViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 30.03.2022.
//

import UIKit
import ObjectMapper

typealias ZikirOlusturSelected = (Bool) -> Void
class ZikirOlusturViewController: UIViewController {
    public var handler: ZikirOlusturSelected? = nil
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textSuperView: UIView!
    var selectedZikr: ZikirObj?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textSuperView.setViewBorder(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //    sayfaya selected zikirle gelmiş isem
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
    //    oluşturulan zikir selected yapılıyor
    private func setSelected(completion: @escaping () -> Void) {
        let tempZikir = Zikir()
        tempZikir.zikir = self.textView.text
        tempZikir.deletable = true
        tempZikir.isSelected = true
        tempZikir.deviceId = FirstSelectViewController.deviceId
        FirebaseClient.setAllData("UserZikr", tempZikir.toJSON()) { result, status in
            if result {
                completion()
            }
        }
    }
    
    //    kullanıcının kendine has oluşturduğu zikirler kayıt atılıyor
    @IBAction func saveButtonAction(_ sender: Any) {
        setOtherZikr {
            self.setSelected {
                let tempZikir = Zikir()
                tempZikir.zikir = self.textView.text
                tempZikir.deletable = true
                tempZikir.deviceId = FirstSelectViewController.deviceId
                FirebaseClient.setAllData("UserCustomZikir", tempZikir.toJSON()){ result, status in
                    if result {
                        showOneButtonAlert(title: "Bilgi", message: "Zikiriniz başarılı bir şekilde kaydedilmiştir.", buttonTitle: "Tamam", view: self) { confirm in
                            if confirm {
                                self.handler?(true)
                                self.dismiss(animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ZikirOlusturViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            view.endEditing(true)
            return false
        } else {
            return true
            
        }
    }
}
