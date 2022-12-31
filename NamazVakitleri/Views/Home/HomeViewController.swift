//
//  HomeViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 5.03.2022.
//

import UIKit
import ObjectMapper


class HomeViewController: UIViewController {
    
    @IBOutlet weak var dailyView: UIView!
    var homeList:[VakitMain] = []
    private var dailyPrayerTimeView: DailyPrayerTimeView? = nil
    var location: Locations?
    var locationsShortDocumentId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.homeList = []
        super.viewWillAppear(animated)
        getData()
        
    }
    
    func getData(){
        LoadingIndicatorView.show(self.view)
        FirebaseClient.getDocWhereCondt("UserInfo", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
            if result {
                self.homeList = []
                for item in response {
                    guard let myLocation = Mapper<UserInfo>().map(JSON: item.document) else { return }
                    self.getVakitsByLocationId(myLocation.locationId)
                }
                LoadingIndicatorView.hide()
            }
        }
    }
    
    func getVakitsByLocationId(_ locationId: String){
        FirebaseClient.getDocRefData("LocationsShort", locationId) { result, locDocumentID, response in
            if result {
                self.locationsShortDocumentId = locDocumentID
                guard let locData = Mapper<Locations>().map(JSON: response) else { return }
                let lastUpdateTimeDate = DateManager.strToDateUgur(strDate: locData.lastUpdateTime)
                let temp = DateManager.checkDate(date: Date(), endDate: lastUpdateTimeDate)
                if temp == .orderedAscending {
                    //                  geride kalmış yeni zaman çek
                    self.location = locData
                    ApiClient.getVakitler(districtId: locData.districtId, completion: self.getVakitlerHandler)
                } else {
                    //                  zaman güncel bunu bas
                    FirebaseClient.getDocRefData("Vakits", locData.vakitId) { result, locDocumentID, response in
                        if result {
                            LoadingIndicatorView.hide()
                            guard let tempObj3 = Mapper<VakitMain>().map(JSON: response) else { return }
                            self.dailyPrayerTimeView = DailyPrayerTimeView.instance()
                            self.dailyPrayerTimeView?.data = tempObj3.vakitList[0]
                        }
                    }
                }
            }
        }
        
    }
    
    func getVakitlerHandler(list: [Vakit]?, status: Bool, message: String) {
        guard status, let responseList = list, let tempObj = self.location else { return }
        FirebaseClient.setVakitListRef(tempObj.vakitId, "Vakits", responseList, tempObj.uniqName) {
            result, status in
            if result {
                self.setLocationsShortData()
            }
        }
    }
    
    func setLocationsShortData() {
        guard let tempObj = self.location else { return }
        tempObj.lastUpdateTime = DateManager.dateToStringUgur(date: Date())
        FirebaseClient.setDocRefData( self.locationsShortDocumentId, "LocationsShort", tempObj.toJSON()) {
            result, locId in
            if result {
            }
        }
    }
    
    
    
    
    
    
}
