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
        tableView.register(UINib(nibName: "DailyPrayTimeViewCell", bundle: nil), forCellReuseIdentifier: "DailyPrayTimeViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData() {
        tempDicsList = []
        LoadingIndicatorView.show(self.view)
        FirebaseClient.getDocTwoWhereCondt("UserInfo", "deviceId", FirstSelectViewController.deviceId, "isFavorite", true) { [weak self] (result, status, response) in
            if result {
                guard let tempObj1 = Mapper<UserInfo>().map(JSON:  response[0].document) else { return }
                FirebaseClient.getDocRefData("LocationsShort", tempObj1.locationId) { result, locDocumentID, response in
                    if result {
                        guard let tempObj2 = Mapper<Locations>().map(JSON: response) else { return }
                        FirebaseClient.getDocRefData("Vakits", tempObj2.vakitId) { result, locDocumentID, response in
                            if result {
                                LoadingIndicatorView.hide()
                                guard let tempObj3 = Mapper<VakitMain>().map(JSON: response) else { return }
//                                self.tempDicsList = tempObj3.vakitList
                                let _dateArr = tempObj3.location.components(separatedBy: ",")
                                let _city = _dateArr[0]
                                let _district = _dateArr[1]
                                self?.labelLocation.text = _city == _district ? _city : tempObj3.location
                                for item in tempObj3.vakitList {
                                    let lastUpdateTimeDate = DateManager.strToDateSuha(strDate: item.MiladiTarihKisa)
                                    let temp = DateManager.checkDate(date: Date(), endDate: lastUpdateTimeDate)
                                    if temp != .orderedAscending{
                                        self?.tempDicsList.append(item)
                                    }
                                }
                                self?.tableView.reloadData()
                            }
                            
                        }
                    }
                }
                
            }
        }
    }
    
}

extension TimeTableViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempDicsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DailyPrayTimeViewCell", for: indexPath) as? DailyPrayTimeViewCell,
              let data = tempDicsList[indexPath.row] as? Vakit else { return UITableViewCell() }
        cell.data = data
        return cell
    }
}
