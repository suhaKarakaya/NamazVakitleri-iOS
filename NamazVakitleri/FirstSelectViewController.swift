//
//  FirstSelectViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 14.02.2022.
//

import UIKit
import Firebase
import ObjectMapper


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
        
        btnSave.layer.cornerRadius = 8
        
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
    
    func getCountyListHandler(list: [Country]?, status: Bool, message: String){
        guard status, let responseList = list else { return }
        if let turkey = responseList.first(where: { $0.UlkeID == "2"}) {
            self.countryList.append(SelectObje.init(strId: turkey.UlkeID ?? "0", value: turkey.UlkeAdi ?? ""))
                
            }
            for item in responseList {
                self.countryList.append(SelectObje.init(strId: item.UlkeID ?? "0", value: item.UlkeAdi ?? ""))
            }
        performSegue(withIdentifier: "sg_picker", sender: PickerType.country)
    }
    
    func getCityListHandler(list: [City]?, status: Bool, message: String){
        guard status, let responseList = list else { return }
        for item in responseList {
            self.cityList.append(SelectObje.init(strId: item.SehirID ?? "0", value: item.SehirAdi ?? ""))
        }
        performSegue(withIdentifier: "sg_picker", sender: PickerType.city)
    }
    
    func getDistrictListHandler(list: [District]?, status: Bool, message: String){
        guard status, let responseList = list else { return }
        for item in responseList {
            self.districtList.append(SelectObje.init(strId: item.IlceID ?? "0", value: item.IlceAdi ?? ""))
        }
        performSegue(withIdentifier: "sg_picker", sender: PickerType.district)
    }
        
    func getLocation(){
        let firestore = Firestore.firestore()
        let docRef = firestore.collection("Locations").document(location)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                guard let myLocation = Mapper<Locations>().map(JSON: document.data() ?? ["":""]) else { return }
                myLocation.toJSON()
                self.setHomeData()
      
            } else {
                self.getVakitlerListener()
            }
        }
    }
    
    func setHomeData(){
        let homeData = FavoriteLocations()
        homeData.isFavorite = true
        homeData.location = ["location" : self.location]
        
        let homeDataList = Home()
        homeDataList.favoriteList.append(homeData)
        
        FirebaseClient.setVakitler(documentName: FirstSelectViewController.deviceId, tableName: "Home", data: homeDataList.toJSON()) { flag, statu in
            guard flag else { return }
            if flag {
                self.performSegue(withIdentifier: "sg_toTabbar", sender: nil)
            }
        }
    }
    
    func getVakitlerListener(){
        guard let country = self.countrySelect, let city = self.citySelect, let district = self.districtSelect else { return alert("Lütfen konumunuzu seçiniz!") }
        ApiClient.getVakitler(districtId: district.strId, completion: self.getVakitlerHandler)
    }
    
    func getVakitlerHandler(list: [Vakit]?, status: Bool, message: String){
        guard status, let responseList = list else { return }
        self.vakitList = responseList
        var vakitDictList: [[String: Any]] = []
        for vakit in self.vakitList {
            vakitDictList.append(vakit.toJSON())
        }
        let loc = Locations()
        loc.locationList = vakitDictList
        loc.lastUpdateTime = DateManager.shared.getTodayString()
        
        FirebaseClient.setVakitler(documentName: location, tableName: "Locations", data: loc.toJSON()) { flag, statu in
            guard flag else { return }
            if flag {
                self.setHomeData()
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
    
    func alert(_ message: String){
        let alert = UIAlertController.init(title: "Uyarı", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "Tamam", style: UIAlertAction.Style.default, handler: { UIAlertAction in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        guard let country = self.countrySelect, let city = self.citySelect, let district = self.districtSelect else { return alert("Lütfen konumunuzu seçiniz!") }
        location = String(format: "%@,%@", city.value,district.value)
        getLocation()
    }
    
}

extension FirstSelectViewController: PickerDelegate{
    func clicked(type: PickerType) {
        switch(type){
        case .country:
            ApiClient.getCountry(completion: self.getCountyListHandler)
            break
        case .city:
            guard let country = self.countrySelect else { return alert("Lütfen ülke seçiniz!") }
            ApiClient.getCity(countyId: country.strId, completion: self.getCityListHandler)
            break
        case .district:
            guard let city = self.citySelect else { return alert("Lütfen şehir seçiniz!") }
            ApiClient.getDistrict(cityId: city.strId, completion: self.getDistrictListHandler)
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


