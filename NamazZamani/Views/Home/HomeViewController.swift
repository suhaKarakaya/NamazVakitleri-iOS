//
//  HomeViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 5.03.2022.
//

import UIKit
import ObjectMapper


class HomeViewController: UIViewController {
    
    @IBOutlet weak var selectedLocationTitleLabel: UILabel!
    @IBOutlet weak var nextPrayValueLabel: UILabel!
    @IBOutlet weak var nextPrayKeyLabel: UILabel!
    @IBOutlet weak var hicriTarihValueLabel: UILabel!
    @IBOutlet weak var miladiTarihValueLabel: UILabel!
    @IBOutlet weak var timeTableview: UIView!
    @IBOutlet weak var yatsiValueLabel: UILabel!
    @IBOutlet weak var aksamValueLabel: UILabel!
    @IBOutlet weak var ikindiValueLabel: UILabel!
    @IBOutlet weak var ogleValueLabel: UILabel!
    @IBOutlet weak var gunesValueLabel: UILabel!
    @IBOutlet weak var imsakValueLabel: UILabel!
    @IBOutlet weak var yatsiKeyLabel: UILabel!
    @IBOutlet weak var aksamKeyLabel: UILabel!
    @IBOutlet weak var ikindiKeyLabel: UILabel!
    @IBOutlet weak var ogleKeyLabel: UILabel!
    @IBOutlet weak var gunesKeyLabel: UILabel!
    @IBOutlet weak var imsakKeyLabel: UILabel!
    @IBOutlet weak var hicriTimeKeyLabel: UILabel!
    @IBOutlet weak var miladiTimeKeyLabel: UILabel!
    @IBOutlet weak var hicriTimeValueLabel: UILabel!
    @IBOutlet weak var miladiTimeValueLabel: UILabel!
    var locationDataId: String?
    var favoriteSelectedLocation: Locations?
    var timer: Timer?
    var favoriteLocationList: [Vakit] = []
    var nextDay = Vakit()
    var strRemainingKey = ""
    var strRemainingValue = ""
    var favoriteLocation: Vakit? = nil {
        didSet {
            guard let data = favoriteLocation else { return }
            miladiTimeValueLabel.text = data.MiladiTarihUzun
            hicriTimeValueLabel.text = data.HicriTarihUzun
            imsakValueLabel.text = data.Imsak
            gunesValueLabel.text = data.Gunes
            ogleValueLabel.text = data.Ogle
            ikindiValueLabel.text = data.Ikindi
            aksamValueLabel.text = data.Aksam
            yatsiValueLabel.text = data.Yatsi
            miladiTimeKeyLabel.text = "Miladi Tarih"
            hicriTimeKeyLabel.text = "Hicri Tarih"
            imsakKeyLabel.text = "İmsak"
            gunesKeyLabel.text = "Güneş"
            ogleKeyLabel.text = "Öğle"
            ikindiKeyLabel.text = "İkindi"
            aksamKeyLabel.text = "Akşam"
            yatsiKeyLabel.text = "Yatsı"
            miladiTarihValueLabel.text = data.MiladiTarihUzun
            hicriTarihValueLabel.text = data.HicriTarihUzun
            LoadingIndicatorView.hide()
       
            
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            }
            timeTableview.setViewBorder(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        
    }
    
    @objc func timerAction(){
        guard let currentDay = favoriteLocation else { return }
        let currentInter = Date().timeIntervalSince1970
        let imsakInter = DateManager.getStrToTimeInterval(strDate: currentDay.MiladiTarihKisa, strTime: currentDay.Imsak)
        let ogleInter = DateManager.getStrToTimeInterval(strDate: currentDay.MiladiTarihKisa, strTime: currentDay.Ogle)
        let ikindiInter = DateManager.getStrToTimeInterval(strDate: currentDay.MiladiTarihKisa, strTime: currentDay.Ikindi)
        let aksamInter = DateManager.getStrToTimeInterval(strDate: currentDay.MiladiTarihKisa, strTime: currentDay.Aksam)
        let yatsiInter = DateManager.getStrToTimeInterval(strDate: currentDay.MiladiTarihKisa, strTime: currentDay.Yatsi)
        let nextImsakInter = DateManager.getStrToTimeInterval(strDate: nextDay.MiladiTarihKisa, strTime: nextDay.Imsak)
        
//        debugPrint(DateManager.getTimeIntervalToDate(time: currentInter))
//        debugPrint(DateManager.getTimeIntervalToDate(time: imsakInter))
//        debugPrint(DateManager.getTimeIntervalToDate(time: ogleInter))
//        debugPrint(DateManager.getTimeIntervalToDate(time: ikindiInter))
//        debugPrint(DateManager.getTimeIntervalToDate(time: aksamInter))
//        debugPrint(DateManager.getTimeIntervalToDate(time: yatsiInter))
//        debugPrint(DateManager.getTimeIntervalToDate(time: nextImsakInter))
        
        let val1 = currentInter - imsakInter
        let val2 = currentInter - ogleInter
        let val3 = currentInter - ikindiInter
        let val4 = currentInter - aksamInter
        let val5 = currentInter - yatsiInter
        let val6 = currentInter - nextImsakInter
        
        if val1 > 0 {
            if val2 > 0 {
                if val3 > 0 {
                    if val4 > 0 {
                        if val5 > 0 {
                            //                            sonraki gün imsaka kalan süre
                            strRemainingKey = "Sabah Ezanına Kalan Süre"
                            strRemainingValue = DateManager.stringFromTimeInterval(interval: -val6)
                        } else {
                            //                            yatsiya kalan süre
                            strRemainingKey = "Yatsı Ezanına Kalan Süre"
                            strRemainingValue = DateManager.stringFromTimeInterval(interval: -val5)
                        }
                        
                    } else {
                        //                        aksama kalan süre
                        strRemainingKey = "Akşam Ezanına Kalan Süre"
                        strRemainingValue = DateManager.stringFromTimeInterval(interval: -val4)
                    }
                    
                } else {
                    //                    ikindiye kalan süre
                    strRemainingKey = "İkindi Ezanına Kalan Süre"
                    strRemainingValue = DateManager.stringFromTimeInterval(interval: -val3)
                }
                
            } else {
                //                oglene kalan süre
                strRemainingKey = "Öğle Ezanına Kalan Süre"
                strRemainingValue = DateManager.stringFromTimeInterval(interval: -val2)
            }
            
        } else {
            //            imsak a kalan süre
            strRemainingKey = "Sabah Ezanına Kalan Süre"
            strRemainingValue = DateManager.stringFromTimeInterval(interval: -val1)
        }
        
        
        nextPrayKeyLabel.text = strRemainingKey
        nextPrayValueLabel.text = strRemainingValue
        
        
    }
    
    func getData(){
        LoadingIndicatorView.show(self.view)
        FirebaseClient.getDocWhereCondt("UserInfo", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
            if result {
                for item in response {
                    guard let myLocation = Mapper<UserInfo>().map(JSON: item.document) else { return }
                    if myLocation.isFavorite {
                        self.getVakitsByLocationId(myLocation.locationId)
                        return
                    }
                }
            } else {
//                bir sorun oluştu alerti
                LoadingIndicatorView.hide()
            }
        }
    }
    
    func getVakitsByLocationId(_ locationId: String){
        FirebaseClient.getDocRefData("LocationsShort", locationId) { result, locDocumentID, response in
            if result {
                guard let locData = Mapper<Locations>().map(JSON: response) else { return }
                let lastUpdateTimeDate = DateManager.strToDateUgur(strDate: locData.lastUpdateTime)
                let temp = DateManager.checkDate(date: Date(), endDate: lastUpdateTimeDate)
                if temp == .orderedAscending {
                    //                  geride kalmış yeni zaman çek
                    self.locationDataId = locDocumentID
                    self.favoriteSelectedLocation = locData
                    ApiClient.shared.fetchPrayerTime(districtId: locData.districtId, completion: self.getVakitlerHandler)
                } else {
                    //                  zaman güncel bunu bas
                    self.getCurrentDay(locData)
                }
            } else {
//                bir sorun oluştu alerti
                LoadingIndicatorView.hide()
            }
        }
        
    }
    
    func getCurrentDay(_ locData:Locations){
        FirebaseClient.getDocRefData("Vakits", locData.vakitId) { result, locDocumentID, response in
            if result {
                LoadingIndicatorView.hide()
                guard let tempObj3 = Mapper<VakitMain>().map(JSON: response) else { return }
                let tempLoc = tempObj3.location.components(separatedBy: ",")
                let city    = tempLoc[0]
                let district = tempLoc[1]
                self.selectedLocationTitleLabel.text = city == district ? city : tempObj3.location
                for item in tempObj3.vakitList {
                    let lastUpdateTimeDate = DateManager.strToDateSuha(strDate: item.MiladiTarihKisa)
                    let temp = DateManager.checkDate(date: Date(), endDate: lastUpdateTimeDate)
                    if temp != .orderedAscending{
                        self.favoriteLocationList.append(item)
                    }
                }
                self.nextDay = self.favoriteLocationList[1]
                self.favoriteLocation = self.favoriteLocationList[0]
            } else {
//                            bir sorun oluştu alerti
                LoadingIndicatorView.hide()
            }
        }
    }
    
    func getVakitlerHandler(list: [Vakit]?, status: Bool, message: String) {
        guard status, let responseList = list else { return }
        FirebaseClient.setVakitListRef(favoriteSelectedLocation?.vakitId ?? "", "Vakits", responseList, favoriteSelectedLocation?.uniqName ?? "") {
            result, status in
            if result {
                self.setLocationsShortData()
            } else {
//                bir sorun oluştu alerti
                LoadingIndicatorView.hide()
            }
        }
    }
    
    func setLocationsShortData() {
        guard let tempObj = self.favoriteSelectedLocation else { return }
        tempObj.lastUpdateTime = DateManager.dateToStringUgur(date: Date())
        FirebaseClient.setDocRefData( self.locationDataId ?? "", "LocationsShort", tempObj.toJSON()) {
            result, locId in
            if result {
                self.getCurrentDay(tempObj)
            } else {
                //                bir sorun oluştu alerti
            }
        }
    }
    
    
    
    
    
    
}
