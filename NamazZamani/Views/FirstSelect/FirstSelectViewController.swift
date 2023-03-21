//
//  FirstSelectViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 14.02.2022.
//

import UIKit
import Firebase
import ObjectMapper
import Foundation


class FirstSelectViewController: UIViewController {
    
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var viewCountryPicker: Picker!
    @IBOutlet weak var viewCityPicker: Picker!
    @IBOutlet weak var viewDistrictPicker: Picker!
    @IBOutlet weak var buttonBack: UIButton!
    let countryPickerView = Picker.instance()
    let cityPickerView = Picker.instance()
    let districtPickerView = Picker.instance()
    var pickerView: PickerViewController? = nil
    var countryList:[SelectObje] = []
    var cityList:[SelectObje] = []
    var districtList:[SelectObje] = []
    var vakitList:[Vakit] = []
    var countrySelect: SelectObje?
    var citySelect: SelectObje?
    var districtSelect: SelectObje?
    var location = ""
    var backVisible: Bool = false
    var locationList: [UserLocationList] = []
    var isUpdate = false
    var locationsShortDocumentId = ""
    var vakitsDocumentId = ""
    static var deviceModel: String = UIDevice.modelName
    static var deviceId: String = UIDevice.current.identifierForVendor!.uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBack.isHidden = !backVisible
        
        stackView.addArrangedSubview(countryPickerView)
        countryPickerView.selectTitleLabel.text = "Ülke"
        
        stackView.addArrangedSubview(cityPickerView)
        cityPickerView.selectTitleLabel.text = "Şehir"
        
        stackView.addArrangedSubview(districtPickerView)
        districtPickerView.selectTitleLabel.text = "Semt"
        
        countryPickerView.type = .country
        cityPickerView.type = .city
        districtPickerView.type = .district
        
        countryPickerView.delegate = self
        cityPickerView.delegate = self
        districtPickerView.delegate = self
        
        
        
        
    }
    
    @IBAction func buttonBackAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getCountyListHandler(list: [Country]?, status: Bool, message: String) {
        self.countryList = []
        guard status, let responseList = list else { return }
        if let turkey = responseList.first(where: { $0.UlkeID == "2" || $0.UlkeAdi == "Türkiye" || $0.UlkeAdiEn == "Turkey" }) {
            self.countryList.append(SelectObje.init(strId: turkey.UlkeID ?? "0", value: turkey.UlkeAdi ?? ""))
        }
        for item in responseList {
            self.countryList.append(SelectObje.init(strId: item.UlkeID ?? "0", value: item.UlkeAdi ?? ""))
        }
        LoadingIndicatorView.hide()
        performSegue(withIdentifier: "sg_picker", sender: PickerType.country)
    }
    
    func getCityListHandler(list: [City]?, status: Bool, message: String) {
        self.cityList = []
        guard status, let responseList = list else { return }
        for item in responseList {
            var id = ""
            var adi = ""
            if let tempId = item.sehirID, let tempAdi = item.sehirAdi {
                id = tempId
                adi = tempAdi
            } else {
                id = item.SehirID ?? "0"
                adi = item.SehirAdi ?? ""
            }
            
            self.cityList.append(SelectObje.init(strId: id, value: adi))
        }
        LoadingIndicatorView.hide()
        performSegue(withIdentifier: "sg_picker", sender: PickerType.city)
    }
    
    func getDistrictListHandler(list: [District]?, status: Bool, message: String) {
        self.districtList = []
        guard status, let responseList = list else { return }
        for item in responseList {
            self.districtList.append(SelectObje.init(strId: item.IlceID ?? "0", value: item.IlceAdi ?? ""))
        }
        LoadingIndicatorView.hide()
        performSegue(withIdentifier: "sg_picker", sender: PickerType.district)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sg_picker" {
            pickerView = segue.destination as? PickerViewController
            pickerView?.delegate = self
            
            if let type = sender as? PickerType {
                switch (type){
                case .country:
                    pickerView?.arrData = PickerSelectedData.init(pickerType: .country, pickerList: self.countryList)
                    break
                case .city:
                    pickerView?.arrData = PickerSelectedData.init(pickerType: .city, pickerList: self.cityList)
                    break
                case .district:
                    pickerView?.arrData = PickerSelectedData.init(pickerType: .district, pickerList: self.districtList)
                    break
                }
            }
        } else if segue.identifier == "sg_toTabPage" {
            guard let data = sender as? LocationDetail, let destinationController = segue.destination as? HomeViewController else { return }
            destinationController.locationData = data
        }
    }
    
    func alert(_ message: String) {
        LoadingIndicatorView.hide()
        showOneButtonAlert(title: "Uyarı", message: message, buttonTitle: "Tamam", view: self) { confirm in
            
        }
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        guard let country = self.countrySelect, let city = self.citySelect, let district = self.districtSelect else { return alert("Lütfen konumunuzu seçiniz!") }
        location = String(format: "%@,%@", city.value,district.value)
        if (locationList.filter({$0.uniqName == location }).count > 0) {
//            Kullanıcı bu sayfaya setting üzerinden gelmiş ve daha önce kendisinde olan kaydı tekrar atmaya çalışırsa alert çıkar
            alert("Bu konum listenizde bulunmaktadır!")
            return
        }
        LoadingIndicatorView.show()
        DispatchQueue.global(qos: .background).async {
            PrayerTimeOrganize.getFirebaseUserData(selectCountry: country, selectCity: city, selectDistrict: district, uniqName: self.location) {
                data, result in
                    if result {
//                        let list = [country.strId, country.value, city.strId, city.value, district.strId, district.value, self.location]
//                        let defaults = UserDefaults.standard
//                        defaults.set(list, forKey: "savedLocationInfo")
//                        do {
//                            let encoder = JSONEncoder()
//                            let _data = try encoder.encode(data)
//                            UserDefaults.standard.set(_data, forKey: "vakit")
//                        } catch {
//                            print("Unable to Encode Note (\(error))")
//                        }
                        DispatchQueue.main.async {
                            LoadingIndicatorView.hide()
                            self.performSegue(withIdentifier: "sg_toTabPage", sender: data)
                          }
                    }
            }
          }
        
   
    }
    
}

extension FirstSelectViewController: PickerDelegate {
    func clicked(type: PickerType) {
        switch(type){
        case .country:
            LoadingIndicatorView.show(self.view)
            ApiClient.shared.fetchCountry(completion: self.getCountyListHandler)
            break
        case .city:
            LoadingIndicatorView.show(self.view)
            guard let country = self.countrySelect else { return alert("Lütfen ülke seçiniz!") }
            ApiClient.shared.fetchCity(countyId: country.strId, completion: self.getCityListHandler)
            break
        case .district:
            LoadingIndicatorView.show(self.view)
            guard let country = self.countrySelect else { return alert("Lütfen ülke seçiniz!") }
            guard let city = self.citySelect else { return alert("Lütfen şehir seçiniz!") }
            ApiClient.shared.fetchDistrict(countyId: country.strId, cityId: city.strId, completion: self.getDistrictListHandler)
            break
        }
    }
}

extension FirstSelectViewController: PickerViewControllerDelegate {
    func iptalClicked() {
        
    }
    
    func selectedValue(_ selected: SelectObje, type: PickerType) {
        switch(type) {
        case .country:
            countryPickerView.selectLabel.text = selected.value
            self.countrySelect = selected
            self.citySelect = nil
            self.districtSelect = nil
            cityPickerView.selectLabel.text = "Seçiniz"
            districtPickerView.selectLabel.text = "Seçiniz"
            break
        case .city:
            cityPickerView.selectLabel.text = selected.value
            self.citySelect = selected
            self.districtSelect = nil
            districtPickerView.selectLabel.text = "Seçiniz"
            break
        case .district:
            districtPickerView.selectLabel.text = selected.value
            self.districtSelect = selected
            break
        }
    }
}
