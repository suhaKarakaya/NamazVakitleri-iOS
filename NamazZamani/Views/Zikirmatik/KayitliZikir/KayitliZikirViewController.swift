//
//  KayitliZikirViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 30.03.2022.
//

import UIKit
import Firebase
import ObjectMapper

typealias KayitliZikirSelected = (Bool) -> Void
class KayitliZikirViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedZikr: ZikirObj?
    var userZikrList: [ZikirObj]?
    public var handler: KayitliZikirSelected? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData(){
        self.userZikrList = []
        LoadingIndicatorView.show(self.view)
        FirebaseClient.getDocWhereCondt("UserZikr", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
            LoadingIndicatorView.hide()
            if result {
                for item in response {
                    guard let tempObj = Mapper<Zikir>().map(JSON:  item.document) else { return }
                    let zikr = ZikirObj()
                    zikr.id = item.documentId
                    zikr.data = tempObj
                    self.userZikrList?.append(zikr)
                }
                self.tableView.reloadData()
            } else {
                // hata elerti ver
                self.tableView.reloadData()
                showOneButtonAlert(title: "Bilgi", message: "Kayıtlı zikiriniz bulunmamaktadır.", buttonTitle: "Tamam", view: self) { confirm in
                    if confirm {
                        self.handler?(true)
                        self.dismiss(animated: true)
                    }
                }
            }
            
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        handler?(true)
        dismiss(animated: true)
    }
    
    private func viewZikr(data: ZikirObj){
        showOneButtonAlert(title: "Bilgi", message: data.data.zikir, buttonTitle: "Tamam", view: self) { confirm in
            
        }
    }
    
    
    
    
    private func toTrash(index: ZikirObj){
        showTwoButtonAlert(title: "Uyarı", message: "Seçmiş olduğunuz zikiri silmek istediğinizden emin misiniz?", button1Title: "Evet", button2Title: "Hayır", view: self){ confirm in
            if confirm {
                FirebaseClient.delete("UserZikr", index.id) { result, status in
                    if result {
                        self.getData()
                    } else {
                        //                    hata alerti göster
                    }
                }
            }
        }
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
    
    
    private func selectZikir(data: ZikirObj){
        setOtherZikr {
            let tempZikr = data
            tempZikr.data.isSelected = true
            FirebaseClient.setDocRefData(data.id, "UserZikr", tempZikr.data.toJSON()){ result, id in
                if result {
                    showOneButtonAlert(title: "Uyarı", message: "Zikir seçim başarılı", buttonTitle: "Tamam", view: self) { confirm in
                        if confirm {
                            self.handler?(true)
                            self.dismiss(animated: true)
                        }
                    }
                    
                } else {
                    showOneButtonAlert(title: "Uyarı", message: "İşlem sırasında bir hata oluştur", buttonTitle: "Tamam", view: self) { confirm in
                    }
                }
            }
        }
    }
    
}

extension KayitliZikirViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userZikrList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: KayitliZikirTableViewCell.identifier, for: indexPath) as! KayitliZikirTableViewCell
        if let data = self.userZikrList?[indexPath.row] {
            cell.setup(data)
            cell.index = indexPath.row
            cell.trashHandler = self.toTrash
            cell.selectHandler = self.selectZikir
            cell.viewZikrHandler = self.viewZikr
        }
        return cell
    }
}
