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
        
//        btnSave.layer.cornerRadius = 8
        
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
//        if let turkey = responseList.first(where: { $0.UlkeID == "2"}) {
//            self.countryList.append(SelectObje.init(strId: turkey.UlkeID ?? "0", value: turkey.UlkeAdi ?? ""))
//                
//            }
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
    
    func getVakitlerHandler(list: [[String]]?, status: Bool, message: String) {
        LoadingIndicatorView.hide()
        guard status, let responseList = list else { return }
        var vakitList: [Vakit] = []
        for var vakit in responseList {
            if vakit[0].contains("&") {
                let tempStr = vakit[0].components(separatedBy: " ")
                let day = tempStr[0]
                let month = tempStr[1]
                let year = tempStr[2]
                let dayStr = tempStr[3]
                vakit[0] = String(format: "%@ %@ %@ %@", day, month, year, "Çarşamba")
            }
            let tempValue = Vakit()
            tempValue.MiladiTarihUzun = vakit[0]
            tempValue.Imsak = vakit[1]
            tempValue.Gunes = vakit[2]
            tempValue.Ogle = vakit[3]
            tempValue.Ikindi = vakit[4]
            tempValue.Aksam = vakit[5]
            tempValue.Yatsi = vakit[6]
            tempValue.MiladiTarihKisa = DateManager.dateToString2(date: DateManager.strToDate1(strDate: vakit[0]))
            
            vakitList.append(tempValue)
        }
        
 
        let list = VakitList()
        list.vakitList = vakitList
        
        LoadingIndicatorView.show(self.view)
        FirebaseClient.setAllData("Vakit", list.toJSON()) { result, vakitId in
            if result {
                LoadingIndicatorView.hide()
                let tempLoc = Locations()
                tempLoc.countryId = self.countrySelect?.strId ?? ""
                tempLoc.countyName = self.countrySelect?.value ?? ""
                tempLoc.cityId = self.citySelect?.strId ?? ""
                tempLoc.cityName = self.citySelect?.value ?? ""
                tempLoc.districtId = self.districtSelect?.strId ?? ""
                tempLoc.districtName = self.districtSelect?.value ?? ""
                tempLoc.lastUpdateTime = DateManager.dateToStringUgur(date: Date())
                tempLoc.vakitId = vakitId
                tempLoc.uniqName = self.location
                
                LoadingIndicatorView.show(self.view)
                FirebaseClient.setAllData("Location", tempLoc.toJSON()) { result, locId in
                    if result {
                        LoadingIndicatorView.hide()
                        let tempObj = FirebaseResponse()
                        tempObj.documentId = locId
                        self.setHomeData(data: tempObj)
                    }
                }
            }
        }
        
        
    }
        
    func getLocation(location: String) {
        LoadingIndicatorView.show(self.view)
        FirebaseClient.getDocWhereCondt("Location", "uniqName", location) { result, status, response in
            if result {
                LoadingIndicatorView.hide()
                self.setHomeData(data: response[0])
            } else {
                LoadingIndicatorView.hide()
                self.getVakitlerListener()
            }
        }

    }
    
    func setHomeData(data: FirebaseResponse) {
        let tempObj = UserLocations()
        tempObj.isFavorite = true
        tempObj.locationId = data.documentId
        tempObj.deviceId = FirstSelectViewController.deviceId
        guard let city = self.citySelect else { return alert("Lütfen şehir seçiniz!") }
        guard let district = self.districtSelect else { return alert("Lütfen semt seçiniz!") }
        tempObj.uniqName = String(format: "%@,%@", district.value,city.value)
        LoadingIndicatorView.show(self.view)
        FirebaseClient.getDocWhereCondt("UserLocations", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
            if result {
                LoadingIndicatorView.hide()
                if response.isEmpty {
                    LoadingIndicatorView.show(self.view)
                    FirebaseClient.setAllData("UserLocations", tempObj.toJSON()) { result, documentId in
                        if result {
                            LoadingIndicatorView.hide()
                            self.performSegue(withIdentifier: "sg_toTabbar", sender: nil)
                        }
                    }
                    
                } else {
                    for item in response {
                        LoadingIndicatorView.show(self.view)
                        guard let myLocation = Mapper<UserLocations>().map(JSON: item.document) else { return }
                        myLocation.isFavorite = false
                        FirebaseClient.setDocRefData(item.documentId, "UserLocations", myLocation.toJSON()) { result, status in
                            if result {
                                LoadingIndicatorView.hide()
                                self.performSegue(withIdentifier: "sg_toTabbar", sender: nil)
                            }
                        }
                    }
                    LoadingIndicatorView.show(self.view)
                    FirebaseClient.setAllData("UserLocations", tempObj.toJSON()) { result, documentId in
                        if result {
                            LoadingIndicatorView.hide()
                            self.performSegue(withIdentifier: "sg_toTabbar", sender: nil)
                        }
                    }
                }
            } else {
                LoadingIndicatorView.show(self.view)
                FirebaseClient.setAllData("UserLocations", tempObj.toJSON()) { result, documentId in
                    if result {
                        LoadingIndicatorView.hide()
                        self.performSegue(withIdentifier: "sg_toTabbar", sender: nil)
                    }
                }
            }
        }

    }
    
    func getVakitlerListener() {
        guard let country = self.countrySelect, let city = self.citySelect, let district = self.districtSelect else { return alert("Lütfen konumunuzu seçiniz!") }
        LoadingIndicatorView.show(self.view)
        ApiClient.getVakitler(districtId: district.strId, completion: self.getVakitlerHandler)
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
            
       
            
        }
    }
    
    func alert(_ message: String) {
        let alert = UIAlertController.init(title: "Uyarı", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        guard let country = self.countrySelect, let city = self.citySelect, let district = self.districtSelect else { return alert("Lütfen konumunuzu seçiniz!") }
        location = String(format: "%@,%@", city.value,district.value)
        getLocation(location: location)
    }
    
}

extension FirstSelectViewController: PickerDelegate{
    func clicked(type: PickerType) {
        switch(type){
        case .country:
            LoadingIndicatorView.show(self.view)
            ApiClient.getCountry(completion: self.getCountyListHandler)
            break
        case .city:
            LoadingIndicatorView.show(self.view)
            guard let country = self.countrySelect else { return alert("Lütfen ülke seçiniz!") }
            ApiClient.getCity(countyId: country.strId, completion: self.getCityListHandler)
            break
        case .district:
            LoadingIndicatorView.show(self.view)
            guard let country = self.countrySelect else { return alert("Lütfen ülke seçiniz!") }
            guard let city = self.citySelect else { return alert("Lütfen şehir seçiniz!") }
            ApiClient.getDistrict(countyId: country.strId, cityId: city.strId, completion: self.getDistrictListHandler)
            break
        }
    }
}

extension FirstSelectViewController: PickerViewControllerDelegate{
    func iptalClicked() {
        
    }
    
    func selectedValue(_ selected: SelectObje, type: PickerType) {
        switch(type) {
        case .country:
            countryPickerView.selectLabel.text = selected.value
            self.countrySelect = selected
            break
        case .city:
            cityPickerView.selectLabel.text = selected.value
            self.citySelect = selected
            break
        case .district:
            districtPickerView.selectLabel.text = selected.value
            self.districtSelect = selected
            break
        }
    }
}


