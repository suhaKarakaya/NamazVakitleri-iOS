//
//  HomeViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 5.03.2022.
//

import UIKit
import ObjectMapper


class HomeViewController: UIViewController {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
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
    var locationData: LocationDetail?
    var locationDataId: String?
    //    var favoriteSelectedLocation: Locations?
    var timer: Timer?
    var favoriteLocationList: [Vakit] = []
    var nextDay = Vakit()
    var strRemainingKey = ""
    var strRemainingValue = ""
    var note: LocationDetail?
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var notify = Notification()
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
        LoadingIndicatorView.show()
        DispatchQueue.global(qos: .background).async {
            PrayerTimeOrganize.getMyLocationData { data, result in
                if result {
                    if let _data = UserDefaults.standard.data(forKey: "notify") {
                        do {
                            self.notify = try self.decoder.decode(Notification.self, from: _data)
                            ScheduleNotification.fetchNotify(timeList: data) { finish in
                                if finish { self.getData(data) }
                            }
                        } catch {
                            print("Unable to Decode Note (\(error))")
                        }
                    } else {
                        self.getData(data)
                    }
//                    if !self.notify.sabahNotfyList.isEmpty && !self.notify.ogleNotfyList.isEmpty && !self.notify.ikindiNotfyList.isEmpty && !self.notify.aksamNotfyList.isEmpty && !self.notify.yatsiNotfyList.isEmpty {
//                        ScheduleNotification.fetchNotify(timeList: data) { finish in
//                            if finish { self.getData(data) }
//                        }
//                    } else {
//                        self.getData(data)
//                    }
                }
            }
        }
    }
    
    private func getData(_ data: LocationDetail){
        DispatchQueue.main.async {
            LoadingIndicatorView.hide()
            self.favoriteLocationList = []
            for item in data.vakitList {
                let lastUpdateTimeDate = DateManager.strToDateSuha(strDate: item.MiladiTarihKisa)
                let temp = DateManager.checkDate(date: Date(), endDate: lastUpdateTimeDate)
                if temp != .orderedAscending{
                    self.favoriteLocationList.append(item)
                }
            }
            self.nextDay = self.favoriteLocationList[1]
            self.favoriteLocation = self.favoriteLocationList[0]
            let tempLoc = data.uniqName.components(separatedBy: ",")
            let city    = tempLoc[0]
            let district = tempLoc[1]
            self.selectedLocationTitleLabel.text = city == district ? city : String(format: "%@\n%@", city, district)
        }
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
    
}
