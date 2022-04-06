//
//  HomeCollectionViewCell.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 28.03.2022.
//

import UIKit
import ObjectMapper

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: HomeCollectionViewCell.self)
    
    @IBOutlet weak var yatsiValueLabel: UILabel!
    @IBOutlet weak var aksamValueLabel: UILabel!
    @IBOutlet weak var ikindiValueLabel: UILabel!
    @IBOutlet weak var ogleValueLabel: UILabel!
    @IBOutlet weak var gunesValueLabel: UILabel!
    @IBOutlet weak var imsakValueLabel: UILabel!
    @IBOutlet weak var yatsiValueView: UIView!
    @IBOutlet weak var aksamValueView: UIView!
    @IBOutlet weak var ikindiValueView: UIView!
    @IBOutlet weak var ogleValueView: UIView!
    @IBOutlet weak var gunesValueView: UIView!
    @IBOutlet weak var imsakValueView: UIView!
    @IBOutlet weak var yatsiKeyLabel: UILabel!
    @IBOutlet weak var aksamKeyLabel: UILabel!
    @IBOutlet weak var ikindiKeyLabel: UILabel!
    @IBOutlet weak var ogleKeyLabel: UILabel!
    @IBOutlet weak var gunesKeyLabel: UILabel!
    @IBOutlet weak var imsakKeyLabel: UILabel!
    @IBOutlet weak var yatsiKeyView: UIView!
    @IBOutlet weak var aksamKeyView: UIView!
    @IBOutlet weak var ikindiKeyView: UIView!
    @IBOutlet weak var ogleKeyView: UIView!
    @IBOutlet weak var gunesKeyView: UIView!
    @IBOutlet weak var imsakKeyView: UIView!
    @IBOutlet weak var currentTimeTableValueView: UIView!
    @IBOutlet weak var currentTimeTableKeyView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var hicriTimeLabel: UILabel!
    @IBOutlet weak var miladiTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTimeTableView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var remainingTimeView: UIView!
    @IBOutlet weak var hicriTimeView: UIView!
    @IBOutlet weak var miladiTimeView: UIView!
    @IBOutlet weak var locationView: UIView!
    
    var timer: Timer?
    var districtId = ""
    var locationDocId = ""
    var vakitDocId = ""
    var currentDay = Vakit()
    var nextDay = Vakit()
    var uniqName = ""
    var locationId = ""
    var strRemainingKey = ""
    var strRemainingValue = " "
    var myView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        currentTimeTableView.setViewBorder(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
    }
    
    func setup() {
        LoadingIndicatorView.show(self.myView)
        FirebaseClient.getDocRefData("Location", locationId) { result, locDocumentID, response in
            if result {
                guard let locData = Mapper<Locations>().map(JSON: response) else { return }
                self.districtId = locData.districtId
                self.locationDocId = locDocumentID
                let obj = HomeScreen()
                obj.location = self.uniqName
                self.setTableList(locData.lastUpdateTime, obj, locData.vakitId)
                }
            }
    }
    
    func setTableList(_ lastUpdateTime: String ,_ obj: HomeScreen, _ vakitId: String) {
        FirebaseClient.getDocRefData("Vakit", vakitId) { result, vakitDocumentID, response in
            if result {
                self.vakitDocId = vakitDocumentID
                guard let vakitData = Mapper<VakitList>().map(JSON: response) else { return }
                let lastUpdateTimeDate = DateManager.strToDateUgur(strDate: lastUpdateTime)
                let temp = DateManager.checkDate(date: Date(), endDate: lastUpdateTimeDate)
                if temp == .orderedAscending {
                    self.getVakitlerListener()
                } else {
                    LoadingIndicatorView.hide()
                    self.currentDay = vakitData.vakitList[0]
                    self.nextDay = vakitData.vakitList[1]
                    
                    self.miladiTimeLabel.text = self.currentDay.MiladiTarihUzun
//                    hicriTimeLabel.text = data.hicriTime
//                    remainingTimeLabel.text = data.remainingTime
                    self.imsakValueLabel.text = self.currentDay.Imsak
                    self.gunesValueLabel.text = self.currentDay.Gunes
                    self.ogleValueLabel.text = self.currentDay.Ogle
                    self.ikindiValueLabel.text = self.currentDay.Ikindi
                    self.aksamValueLabel.text = self.currentDay.Aksam
                    self.yatsiValueLabel.text = self.currentDay.Yatsi
                    
                    let tempLoc = obj.location.components(separatedBy: ",")
                    let city    = tempLoc[0]
                    let district = tempLoc[1]
                    self.locationLabel.text = city == district ? city : obj.location
                    
                    if self.timer == nil {
                        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                    }

                }
                
            }
        }
    }
    
    func getVakitlerListener(){
        ApiClient.getVakitler(districtId: self.districtId, completion: self.getVakitlerHandler)
    }
    
    func getVakitlerHandler(list: [[String]]?, status: Bool, message: String){
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
        
        
        FirebaseClient.updateString("Location", self.locationDocId, "lastUpdateTime", DateManager.dateToStringUgur(date: Date())) { result, status in
            if result {
                FirebaseClient.setDocRefData(self.vakitDocId, "Vakit", list.toJSON()) { result, status in
                    if result {
                        LoadingIndicatorView.hide()
                        self.setup()
                    }
                }
            }
        }
        
    }
    

    

    
    

    
    
    
    @objc func timerAction(){
        let currentInter = Date().timeIntervalSince1970
        let imsakInter = DateManager.getStrToTimeInterval(strDate: currentDay.MiladiTarihKisa, strTime: currentDay.Imsak)
        let ogleInter = DateManager.getStrToTimeInterval(strDate: currentDay.MiladiTarihKisa, strTime: currentDay.Ogle)
        let ikindiInter = DateManager.getStrToTimeInterval(strDate: currentDay.MiladiTarihKisa, strTime: currentDay.Ikindi)
        let aksamInter = DateManager.getStrToTimeInterval(strDate: currentDay.MiladiTarihKisa, strTime: currentDay.Aksam)
        let yatsiInter = DateManager.getStrToTimeInterval(strDate: currentDay.MiladiTarihKisa, strTime: currentDay.Yatsi)
        let nextImsakInter = DateManager.getStrToTimeInterval(strDate: nextDay.MiladiTarihKisa, strTime: nextDay.Imsak)
        
        debugPrint(DateManager.getTimeIntervalToDate(time: currentInter))
        debugPrint(DateManager.getTimeIntervalToDate(time: imsakInter))
        debugPrint(DateManager.getTimeIntervalToDate(time: ogleInter))
        debugPrint(DateManager.getTimeIntervalToDate(time: ikindiInter))
        debugPrint(DateManager.getTimeIntervalToDate(time: aksamInter))
        debugPrint(DateManager.getTimeIntervalToDate(time: yatsiInter))
        debugPrint(DateManager.getTimeIntervalToDate(time: nextImsakInter))
      
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
        
        
        remainingTimeLabel.text = strRemainingKey
        timeLabel.text = strRemainingValue
        
        
        }
}
