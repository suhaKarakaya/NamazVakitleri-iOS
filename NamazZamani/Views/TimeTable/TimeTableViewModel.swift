//
//  TimeTableViewModel.swift
//  NamazZamani
//
//  Created by Süha Karakaya on 14.01.2023.
//

import Foundation
import ObjectMapper

protocol TimeTableViewModelInterface {
    var view: TimeTableViewInterface? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func numberOfRowsInSection() -> (Int)
    func cellForRowAt(indexPath: IndexPath) -> (Vakit)
}

final class TimeTableViewModel {
    weak var view: TimeTableViewInterface?
    private var tempDicsList: [Vakit] = []
    
    func getData(completion: @escaping([Vakit]?) -> ()) {
        tempDicsList = []
        view?.startLoading()
        FirebaseClient.getDocTwoWhereCondt("UserInfo", "deviceId", FirstSelectViewController.deviceId, "isFavorite", true) { [weak self] (result, status, response) in
            if result {
                guard let tempObj1 = Mapper<UserInfo>().map(JSON:  response[0].document) else { return }
                FirebaseClient.getDocRefData("LocationsShort", tempObj1.locationId) { result, locDocumentID, response in
                    if result {
                        guard let tempObj2 = Mapper<Locations>().map(JSON: response) else { return }
                        FirebaseClient.getDocRefData("Vakits", tempObj2.vakitId) { [weak self] (result, locDocumentID, response) in
                            if result {
                                self?.view?.stopLoading()
                                guard let tempObj3 = Mapper<VakitMain>().map(JSON: response) else { return }
//                                self.tempDicsList = tempObj3.vakitList
                                let _dateArr = tempObj3.location.components(separatedBy: ",")
                                let _city = _dateArr[0]
                                let _district = _dateArr[1]
                                self?.view?.setLabelLocation(title: _city == _district ? _city : tempObj3.location)
                                for item in tempObj3.vakitList {
                                    let lastUpdateTimeDate = DateManager.strToDateSuha(strDate: item.MiladiTarihKisa)
                                    let temp = DateManager.checkDate(date: Date(), endDate: lastUpdateTimeDate)
                                    if temp != .orderedAscending{
                                        self?.tempDicsList.append(item)
                                    }
                                }
                                completion(self?.tempDicsList)
                            }
                        }
                    }
                }
                
            }
        }
    }
}

extension TimeTableViewModel: TimeTableViewModelInterface {
    func numberOfRowsInSection() -> (Int) {
        return tempDicsList.count
    }
    
    func cellForRowAt(indexPath: IndexPath) -> (Vakit) {
        return tempDicsList[indexPath.row]
    }
    
    func viewDidLoad() {
        view?.prepareTableView()
    }
    
    func viewWillAppear() {
        getData { result in
            guard let tempList = result else { return }
            self.view?.prepareGetData(tempDicsList: tempList)
        }
    }
    
    
}
