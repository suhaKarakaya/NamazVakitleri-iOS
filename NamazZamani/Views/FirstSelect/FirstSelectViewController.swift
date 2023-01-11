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
    var documentIdList: [LocationList] = []
    var isUpdate = false
    var locationsShortDocumentId = ""
    var vakitsDocumentId = ""
    
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
    
    func getLocation(location: String) {
        LoadingIndicatorView.show(self.view)
        FirebaseClient.getDocWhereCondt("LocationsShort", "uniqName", location) { result, status, response in
            if result {
//                Seçilen location değeri firebase sistemine daha önce yazılmış
                if response != nil && !response.isEmpty {
                    guard let tempObj = Mapper<Locations>().map(JSON:  response[0].document) else { return }
                    let lastUpdateTimeDate = DateManager.strToDateUgur(strDate: tempObj.lastUpdateTime)
                    let temp = DateManager.checkDate(date: Date(), endDate: lastUpdateTimeDate)
                    if temp == .orderedAscending {
//                        Daha önce yazılan location değeri day olarak geride kalmış yenisini apiden çekmek gerek
                        self.getVakitlerListener(_isUpdate: true, _locationsShortDocumentId: response[0].documentId, _vakitsDocumentId: tempObj.vakitId)
                    } else {
//                        Firebase üzerinde güncel veri bulunmakta
                        self.setHomeData(data: response[0])
                    }
                } else {
//                    Seçilen location değeri firebasede yok apiden çekmek gerek
                    self.getVakitlerListener(_isUpdate: false, _locationsShortDocumentId:"", _vakitsDocumentId: "")
                }
            } else {
//                    Seçilen location değeri firebasede yok apiden çekmek gerek
                self.getVakitlerListener(_isUpdate: false, _locationsShortDocumentId:"",_vakitsDocumentId: "")
            }
        }
        
    }
    
    func getVakitlerListener(_isUpdate: Bool, _locationsShortDocumentId: String, _vakitsDocumentId: String) {
        guard let country = self.countrySelect, let city = self.citySelect, let district = self.districtSelect else { return alert("Lütfen konumunuzu seçiniz!") }
        ApiClient.getVakitler(districtId: district.strId, completion: self.getVakitlerHandler)
        isUpdate = _isUpdate
        vakitsDocumentId = _vakitsDocumentId
        locationsShortDocumentId = _locationsShortDocumentId
    }
    
    func getVakitlerHandler(list: [Vakit]?, status: Bool, message: String) {
        guard status, let responseList = list else { return }
        if vakitsDocumentId.isEmpty {
//            seçilen location değeri firebase üzerinde daha önce yok ilk defa yazılıyor
            FirebaseClient.setVakitList("Vakits", responseList, self.location) { result, vakitId in
                if result {
                    self.setLocationsShortData(vakitId)
                }
            }
        } else {
//            seçilen location değeri daha önce firebase üzerinde var fakat güncel day değil. Üzerinde yazılacak
            FirebaseClient.setVakitListRef(vakitsDocumentId, "Vakits", responseList, self.location) {
                result, status in
                if result {
                    self.setLocationsShortData(self.vakitsDocumentId)
                }
            }
        }
    }
    
    func setLocationsShortData(_ vakitId: String) {
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
        if self.isUpdate {
//            seçilen location değeri daha önce firebase üzerinde var fakat güncel day değil. Üzerinde yazılacak
            FirebaseClient.setDocRefData( self.locationsShortDocumentId, "LocationsShort", tempLoc.toJSON()) {
                result, locId in
                if result {
                    let tempObj = FirebaseResponse()
                    tempObj.documentId = locId
                    self.setHomeData(data: tempObj)
                }
            }
        } else {
//            seçilen location değeri firebase üzerinde daha önce yok ilk defa yazılıyor
            FirebaseClient.setAllData("LocationsShort", tempLoc.toJSON()) { result, locId in
                if result {
                    let tempObj = FirebaseResponse()
                    tempObj.documentId = locId
                    self.setHomeData(data: tempObj)
                }
            }
        }
    }
    
    func setHomeData(data: FirebaseResponse) {
        let tempObj = UserInfo()
        tempObj.isFavorite = true
        tempObj.locationId = data.documentId
        tempObj.deviceId = FirstSelectViewController.deviceId
        guard let city = self.citySelect else { return alert("Lütfen şehir seçiniz!") }
        guard let district = self.districtSelect else { return alert("Lütfen semt seçiniz!") }
        tempObj.uniqName = String(format: "%@,%@", city.value,district.value)
        FirebaseClient.getDocWhereCondt("UserInfo", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
            if result {
                if response.isEmpty {
//                Kullanıcının daha önce kaydı olmadığı için ilk defa kayıt atılıyor
                    FirebaseClient.setAllData("UserInfo", tempObj.toJSON()) { result, documentId in
                        if result {
                            LoadingIndicatorView.hide()
                            self.performSegue(withIdentifier: "sg_toTabbar", sender: nil)
                        }
                    }
                } else {
//                    Kullanıcının daha önce kaydı var. Daha önceki kayıtlar isFavorite false yapılıp güncelleniyor ve yeni kayıt ayrıca atılıyor
                    for item in response {
                        guard let myLocation = Mapper<UserInfo>().map(JSON: item.document) else { return }
                        myLocation.isFavorite = myLocation.uniqName.elementsEqual(self.location) ? true : false
                        FirebaseClient.setDocRefData(item.documentId, "UserInfo", myLocation.toJSON()) { result, status in
                        }
                    }
                    FirebaseClient.setAllData( "UserInfo", tempObj.toJSON()) { result, status in
                        if result {LoadingIndicatorView.hide()}
                    }
                    
                    self.performSegue(withIdentifier: "sg_toTabbar", sender: nil)
                }
            } else {
//                Kullanıcının daha önce kaydı olmadığı için ilk defa kayıt atılıyor
                FirebaseClient.setAllData("UserInfo", tempObj.toJSON()) { result, documentId in
                    if result {
                        LoadingIndicatorView.hide()
                        self.performSegue(withIdentifier: "sg_toTabbar", sender: nil)
                    }
                }
            }
        }
        
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
        LoadingIndicatorView.hide()
        showOneButtonAlert(title: "Uyarı", message: message, buttonTitle: "Tamam", view: self) { confirm in
            
        }
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        guard let country = self.countrySelect, let city = self.citySelect, let district = self.districtSelect else { return alert("Lütfen konumunuzu seçiniz!") }
        location = String(format: "%@,%@", city.value,district.value)
        if (documentIdList.filter({$0.userLocation.uniqName == location }).count > 0) {
//            Kullanıcı bu sayfaya setting üzerinden gelmiş ve daha önce kendisinde olan kaydı tekrar atmaya çalışırsa alert çıkar
            alert("Bu konum listenizde bulunmaktadır!")
            return
        }
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

extension FirstSelectViewController: PickerViewControllerDelegate {
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


