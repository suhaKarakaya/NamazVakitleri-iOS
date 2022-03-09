//
//  FirebaseResponseModel.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 3.03.2022.
//

import Foundation
import ObjectMapper

class Locations: NSObject,Mappable {
    var lastUpdateTime: String = ""
    var locationList: [[String: Any]] = [[:]]
    var isFavorite: Bool = false
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map){
        lastUpdateTime <- map["lastUpdateTime"]
        locationList <- map["locationList"]
        isFavorite <- map["isFavorite"]
    }
    
    
}

class FavoriteLocations: NSObject,Mappable {
    
    var location: [String: Any] = [:]
    var isFavorite: Bool = false
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map){
        isFavorite <- map["isFavorite"]
        location <- map["location"]
    }
    
    
}

class Home: NSObject,Mappable {
    
    var favoriteList: [FavoriteLocations] = []
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map){
        
        favoriteList <- map["favoriteList"]
    }
    
    
}
