//
//  HomeCollectionViewCell.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 28.03.2022.
//

import UIKit

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
    
    var data: HomeScreen?
//  var data = HomeScreen()
    var timer: Timer?
    
    var strRemainingKey = ""
    var strRemainingValue = " "
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        currentTimeTableView.setViewBorder(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
        
 
  
    }
    
    
    func setup(_ data: HomeScreen) {
        self.data = data
        
        
        miladiTimeLabel.text = data.miladiTimeUzun
        hicriTimeLabel.text = data.hicriTime
//        remainingTimeLabel.text = data.remainingTime
        imsakValueLabel.text = data.imsakTime
        gunesValueLabel.text = data.gunesTime
        ogleValueLabel.text = data.ogleTime
        ikindiValueLabel.text = data.ikindiTime
        aksamValueLabel.text = data.aksamTime
        yatsiValueLabel.text = data.yatsiTime
        
        let tempLoc = data.location.components(separatedBy: ",")
        let city    = tempLoc[0]
        let district = tempLoc[1]
        locationLabel.text = city == district ? city : data.location
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
      
    }
    
    @objc func timerAction(){
        guard let data = data else { return }
        let currentInter = Date().timeIntervalSince1970
        let imsakInter = DateManager.getStrToTimeInterval(strDate: data.miladiTimeKisa, strTime: data.imsakTime)
        let ogleInter = DateManager.getStrToTimeInterval(strDate: data.miladiTimeKisa, strTime: data.ogleTime)
        let ikindiInter = DateManager.getStrToTimeInterval(strDate: data.miladiTimeKisa, strTime: data.ikindiTime)
        let aksamInter = DateManager.getStrToTimeInterval(strDate: data.miladiTimeKisa, strTime: data.aksamTime)
        let yatsiInter = DateManager.getStrToTimeInterval(strDate: data.miladiTimeKisa, strTime: data.yatsiTime)
        let nextImsakInter = DateManager.getStrToTimeInterval(strDate: data.nextDay, strTime: data.nextDayImsakTime)
        
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
        
        
        remainingTimeLabel.text = strRemainingKey
        timeLabel.text = strRemainingValue
        
        
        }
}
