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
        PrayerTimeOrganize.getMyLocationData { [weak self] data, _result in
            if _result {
                self?.view?.stopLoading()
                let _dateArr = data.uniqName.components(separatedBy: ",")
                let _city = _dateArr[0]
                let _district = _dateArr[1]
                self?.view?.setLabelLocation(title: _city == _district ? _city : data.uniqName)
                for item in data.vakitList {
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
