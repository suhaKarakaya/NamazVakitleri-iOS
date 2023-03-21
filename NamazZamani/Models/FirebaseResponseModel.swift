//
//  FirebaseResponseModel.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 3.03.2022.
//

import Foundation
import ObjectMapper

class UserInfo: NSObject,Mappable {
    var deviceModel: String = ""
    var deviceId: String = ""
    var locationList: [UserLocationList] = []
    
    override init() { super.init() }
    
    required init?(map: Map) {}
    
    func mapping(map: Map){
        deviceModel <- map["deviceModel"]
        deviceId <- map["deviceId"]
        locationList <- map["locationList"]
    }
}

class UserLocationList: NSObject,Mappable {
    var uniqName: String = ""
    var isFavorite: Bool = false
    
    override init() { super.init() }
    
    required init?(map: Map) {}
    
    func mapping(map: Map){
        uniqName <- map["uniqName"]
        isFavorite <- map["isFavorite"]
    }
}

class LocationDetail: NSObject,Mappable,Codable {
    var uniqName: String = ""
    var lastUpdateTime: String = ""
    var vakitList: [Vakit] = []
    var countryId: String = ""
    var countyName: String = ""
    var cityId: String = ""
    var cityName: String = ""
    var districtId: String = ""
    var districtName: String = ""
    
    override init() { super.init() }
    required init?(map: Map) {}
    
    func mapping(map: Map){
        countryId <- map["countryId"]
        countyName <- map["countyName"]
        cityId <- map["cityId"]
        cityName <- map["cityName"]
        districtId <- map["districtId"]
        districtName <- map["districtName"]
        lastUpdateTime <- map["lastUpdateTime"]
        uniqName <- map["uniqName"]
        vakitList <- map["vakitList"]
    }
}

class VakitMain: NSObject,Mappable {
    var location: String = ""
    var vakitList: [Vakit] = []

    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map){
        location <- map["location"]
        vakitList <- map["vakitList"]

    }
    
    
}

class Vakit: NSObject,Mappable,Codable {
    var Aksam: String = ""
    var Gunes: String = ""
    var GunesBatis: String = ""
    var GunesDogus: String = ""
    var HicriTarihKisa: String = ""
    var HicriTarihUzun: String = ""
    var Ikindi: String = ""
    var Imsak: String = ""
    var KibleSaati: String = ""
    var MiladiTarihKisa: String = ""
    var MiladiTarihUzun: String = ""
    var Ogle: String = ""
    var Yatsi: String = ""
    
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
        Aksam <- map["Aksam"]
        Gunes <- map["Gunes"]
        GunesBatis <- map["GunesBatis"]
        GunesDogus <- map["GunesDogus"]
        HicriTarihKisa <- map["HicriTarihKisa"]
        HicriTarihUzun <- map["HicriTarihUzun"]
        Ikindi <- map["Ikindi"]
        Imsak <- map["Imsak"]
        KibleSaati <- map["KibleSaati"]
        KibleSaati <- map["KibleSaati"]
        MiladiTarihKisa <- map["MiladiTarihKisa"]
        MiladiTarihUzun <- map["MiladiTarihUzun"]
        Ogle <- map["Ogle"]
        Yatsi <- map["Yatsi"]
    }
}

class Zikir: NSObject,Mappable,Codable {
    var zikir: String = ""
    var aciklamasi: String = ""
    var kaynak: String = ""
    var deletable: Bool = false
    var count: Int64 = 0
    var isSelected: Bool = false
    var deviceId: String = ""
 
    
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
        zikir <- map["zikir"]
        aciklamasi <- map["aciklamasi"]
        kaynak <- map["kaynak"]
        deletable <- map["deletable"]
        count <- map["count"]
        isSelected <- map["isSelected"]
        deviceId <- map["deviceId"]
        

    }
}

class ZikirListModel: NSObject,Mappable,Codable {
    var zikirList: [Zikir] = []
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
        zikirList <- map["zikirList"]
    }
}

class FirebaseResponse: NSObject,Mappable {
    var document: [String:Any] = [:]
    var documentId: String = ""
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
        document <- map["document"]
        documentId <- map["documentId"]
        
    }
}

class ZikirObj: NSObject,Mappable {
    var data = Zikir()
    var id = ""
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        id <- map["id"]
        
    }
}







