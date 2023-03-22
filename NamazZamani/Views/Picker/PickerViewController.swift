//
//  PickerViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 16.02.2022.
//

import UIKit

protocol PickerViewControllerDelegate: AnyObject{
    func iptalClicked();
    func selectedValue(_ selected: SelectObje, type: PickerType);
}

class PickerViewController: UIViewController {
    
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var btnTamam: UIBarButtonItem!
    weak var delegate: PickerViewControllerDelegate?
    
    var arrData: PickerSelectedData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnTamam.title = "Tamam"
        btnCancel.title = "İptal"
        btnTamam.tintColor = UIColor.systemBrown
        btnCancel.tintColor = UIColor.systemBrown
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.reloadComponent(0)
    }
    
    @IBAction func pickerCancelClicked(_ sender: Any) {
        delegate?.iptalClicked()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickerTamamClicked(_ sender: Any) {
        guard let list = self.arrData?.pickerList else { return }
        guard let type = self.arrData?.pickerType else { return  }
        if list.isEmpty {
            return;
        }
        
        dismiss(animated: true){
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.delegate?.selectedValue(SelectObje.init(strId: list[row].strId, value: list[row].value), type: type)
        }
    }
    
}

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let title = arrData?.pickerList[row].value else { return "" }
        return title
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let count = arrData?.pickerList.count else { return 0}
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributedString: NSAttributedString!
        
        attributedString = NSAttributedString(string: arrData?.pickerList[row].value ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "kabeBlack") ?? UIColor.white])
        
        return attributedString
    }
    
    
}


class PickerSelectedData {
    var pickerType: PickerType
    var pickerList: [SelectObje]
    init(pickerType: PickerType, pickerList: [SelectObje]) {
        self.pickerType  = pickerType
        self.pickerList = pickerList
    }
    
}
class SelectObje {
    var id: Int?
    var strId: String
    var value: String
    init (strId: String, value: String ) {
        self.strId = strId
        self.value = value
    }
}
enum PickerType {
    case country
    case city
    case district
}
