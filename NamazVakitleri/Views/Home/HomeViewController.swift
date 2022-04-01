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
    typealias ListReturn = (HomeScreen, Bool, String) -> Void
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.pageControl.numberOfPages = 0 
        self.homeList = []
        super.viewWillAppear(animated)
        FirebaseClient.getDocRefData("User", FirstSelectViewController.deviceId) { result, documentId, response in
            if result {
                guard let myLocation = Mapper<User>().map(JSON: response) else { return }
                myLocation.toJSON()
                self.pageControl.numberOfPages = myLocation.locations.count
                for item in myLocation.locations {
                    let obj = HomeScreen()
                    obj.location = item.location
                    self.setTableList(obj, completion: self.setListHandler)
                    
                }
            }
        }
        
    }
    
    
    func setListHandler(rObj: HomeScreen, status: Bool, message: String){
        self.homeList.append(rObj)
        self.collectionView.reloadData()
    }
    
    func setTableList(_ obj: HomeScreen, completion: @escaping ListReturn) {
        FirebaseClient.getDocRefData("Locations", obj.location) { result, documentId, response in
            if result {
                guard let myLocation = Mapper<ApiLocations>().map(JSON: response) else { return }
                myLocation.toJSON()
                var currentDay = myLocation.timeList[0]
                var nextDay = myLocation.timeList[1]
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


