//
//  HomeViewController.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 5.03.2022.
//

import UIKit
import ObjectMapper

class HomeViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    var homeList:[UserLocations] = []
    var currentPage = 0
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
                self.homeList = []
                for item in response {
                    guard let myLocation = Mapper<UserLocations>().map(JSON: item.document) else { return }
                    self.homeList.append(myLocation)
                }
                self.collectionView.reloadData()
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
        cell.myView = self.view
        cell.locationId = self.homeList[indexPath.row].locationId
        cell.uniqName = self.homeList[indexPath.row].uniqName
        cell.setup()
    
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


