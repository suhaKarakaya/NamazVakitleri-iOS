//
//  HomeViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 5.03.2022.
//

import UIKit
import Firebase
import ObjectMapper

class HomeViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var homeList:[HomeScreen] = []
    var currentPage = 0
    var pageCount = 0
    var districtId = ""
    var locationDocId = ""
    var vakitDocId = ""
    typealias ListReturn = (HomeScreen, Bool, String) -> Void
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pageControl.numberOfPages = 0 
        self.homeList = []
        super.viewWillAppear(animated)
        getData()
        
    }
    
    func getData(){
        LoadingIndicatorView.show(self.view)
        FirebaseClient.getDocWhereCondt("UserLocations", "deviceId", FirstSelectViewController.deviceId) { result, status, response in
            if result {
                LoadingIndicatorView.hide()
                self.pageControl.numberOfPages = response.count
                self.pageCount = response.count
                for item in response {
                
                    guard let myLocation = Mapper<UserLocations>().map(JSON: item.document) else { return }
                    FirebaseClient.getDocRefData("Location", myLocation.locationId) { result, locDocumentID, response in
                        if result {
                            guard let locData = Mapper<Locations>().map(JSON: response) else { return }
                            self.districtId = locData.districtId
                            self.locationDocId = locDocumentID
                            let obj = HomeScreen()
                            obj.location = myLocation.uniqName
                            self.setTableList(locData.lastUpdateTime, obj, locData.vakitId, completion: self.setListHandler)
           
                        }
                        
                    }
                    
                    
                }
            }
        }
    }
    
    
    func setListHandler(rObj: HomeScreen, status: Bool, message: String){
        self.homeList.append(rObj)
        self.collectionView.reloadData()
        
    }
    
    func setTableList(_ lastUpdateTime: String ,_ obj: HomeScreen, _ vakitId: String, completion: @escaping ListReturn) {
        
        
        
        FirebaseClient.getDocRefData("Vakit", vakitId) { result, vakitDocumentID, response in
            if result {
                self.vakitDocId = vakitDocumentID
                guard let vakitData = Mapper<VakitList>().map(JSON: response) else { return }
                let lastUpdateTimeDate = DateManager.strToDateUgur(strDate: lastUpdateTime)
                let temp = DateManager.checkDate(date: Date(), endDate: lastUpdateTimeDate)
                if temp == .orderedAscending {
                    self.getVakitlerListener()
                } else {
                    let currentDay = vakitData.vakitList[0]
                    let nextDay = vakitData.vakitList[1]
                    obj.miladiTimeKisa = currentDay.MiladiTarihKisa
                    obj.miladiTimeUzun = currentDay.MiladiTarihUzun
    //                    obj.hicriTime = tempDics["HicriTarihUzun"] as? String ?? ""
                    obj.imsakTime = currentDay.Imsak
                    obj.gunesTime = currentDay.Gunes
                    obj.ogleTime = currentDay.Ogle
                    obj.ikindiTime = currentDay.Ikindi
                    obj.aksamTime = currentDay.Aksam
                    obj.yatsiTime = currentDay.Yatsi
                    obj.nextDay = nextDay.MiladiTarihKisa
                    obj.nextDayImsakTime = nextDay.Imsak


                    completion(obj, true, "Success")
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
    
}
    
    


extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as! HomeCollectionViewCell

        cell.setup(self.homeList[indexPath.row])
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
        
        
    }
    
    
    
    
}


