//
//  TimeTableViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 5.03.2022.
//

import UIKit
import Firebase
import ObjectMapper

class TimeTableViewController: UIViewController {
    
    

    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var loc:String = ""
    var tempDicsList: [Vakit] = []
    var districtId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.register(TimeViewCell.self, forCellReuseIdentifier: "timeTableCell")
        
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
        
        
//        let loc = ApiLocations()
//        loc.timeList = vakitList
//        loc.districtId = self.districtId
//        loc.lastUpdateTime = DateManager.dateToStringUgur(date: Date())
//
//        FirebaseClient.setDocRefData(self.loc, "Locations", loc.toJSON()) { flag, statu in
//            guard flag else { return }
//            if flag {
//                self.getData()
//            }
//        }
        
    }
    
    func getData() {
        tempDicsList = []
            
//        FirebaseClient.getDocRefData("User", FirstSelectViewController.deviceId) { flag, documentId, response in
//            if flag {
//                guard let userData = Mapper<User>().map(JSON: response) else { return }
//                for item in userData.locations {
//                    if item.isFavorite {
//                        self.loc = item.location
//                        self.labelLocation.text = self.loc
//                    }
//                }
//                
//                FirebaseClient.getDocRefData("Locations", self.loc) { flag, documentID, response in
//                    if flag {
//                        guard let myLocation = Mapper<ApiLocations>().map(JSON: response) else { return }
//                        self.districtId = myLocation.districtId
//                        var lastUpdateTimeDate = DateManager.strToDateUgur(strDate: myLocation.lastUpdateTime)
//                        let temp = DateManager.checkDate(date: Date(), endDate: lastUpdateTimeDate)
//                        if temp == .orderedAscending {
//                            self.getVakitlerListener()
//                        } else {
//                            self.tempDicsList = myLocation.timeList
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//               
//            }
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
}

extension TimeTableViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempDicsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeTableCell", for: indexPath) as! TimeViewCell
        
        var tempDics:Vakit = self.tempDicsList[indexPath.row]
        
        cell.labelMiladiTarihValue.text = tempDics.MiladiTarihUzun
//        cell.labelHicriTarihValue.text = tempDics["HicriTarihUzun"] as? String ?? ""
        cell.labelImsakValue.text = tempDics.Imsak
        cell.labelGunesValue.text = tempDics.Gunes
        cell.labelOgleValue.text = tempDics.Ogle
        cell.labelIkindiValue.text = tempDics.Ikindi
        cell.labelAksamValue.text = tempDics.Aksam
        cell.labelYatsiValue.text = tempDics.Yatsi
        
        return cell

    
    }
    

    
    
}
