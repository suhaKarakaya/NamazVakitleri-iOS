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
    var locationDocId = ""
    var vakitDocId = ""
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
        
        
        let list = VakitList()
        list.vakitList = vakitList
        
        LoadingIndicatorView.show(self.view)
        FirebaseClient.updateString("Location", self.locationDocId, "lastUpdateTime", DateManager.dateToStringUgur(date: Date())) { result, status in
            if result {
                FirebaseClient.setDocRefData(self.vakitDocId, "Vakit", list.toJSON()) { result, status in
                    if result {
                        LoadingIndicatorView.hide()
                        self.getData()
                    }
                }
            }
        }
        
    }
    
    func getData() {
        tempDicsList = []
        LoadingIndicatorView.show(self.view)
        FirebaseClient.getDocWhereCondt("UserLocations", "isFavorite", true) { result, status, response in
            if result {
                guard let userMainData = Mapper<UserLocations>().map(JSON: response[0].document) else { return }
                FirebaseClient.getDocRefData("Location", userMainData.locationId) { result, locDocumentID, response in
                    if result {
                        self.locationDocId = locDocumentID
                        guard let userData = Mapper<Locations>().map(JSON: response) else { return }
                        self.districtId = userData.districtId
                        self.labelLocation.text = userData.uniqName
                        FirebaseClient.getDocRefData("Vakit", userData.vakitId) { result, vakitDocumentID, response in
                            if result {
                                LoadingIndicatorView.hide()
                                self.vakitDocId = vakitDocumentID
                                guard let vakitData = Mapper<VakitList>().map(JSON: response) else { return }
                                let lastUpdateTimeDate = DateManager.strToDateUgur(strDate: userData.lastUpdateTime)
                                let temp = DateManager.checkDate(date: Date(), endDate: lastUpdateTimeDate)
                                if temp == .orderedAscending {
                                    self.getVakitlerListener()
                                } else {
                                    self.tempDicsList = vakitData.vakitList
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                    
                }
            }
        }

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
