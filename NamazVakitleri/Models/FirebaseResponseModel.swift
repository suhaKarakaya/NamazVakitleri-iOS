//
//  FirebaseResponseModel.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 3.03.2022.
//

import Foundation
import ObjectMapper

class User: NSObject,Mappable {
    
    var locations: [UserLocations] = []
    var saveZikirList: [SelectZikir] = []
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map){
        
        locations <- map["locations"]
        saveZikirList <- map["saveZikirList"]
    }

}

class UserLocations: NSObject,Mappable {
    
    var location: String = ""
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

class ApiLocations: NSObject,Mappable {
    var lastUpdateTime: String = ""
    var districtId: String = ""
    var timeList: [Vakit] = []
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map){
        lastUpdateTime <- map["lastUpdateTime"]
        districtId <- map["districtId"]
        timeList <- map["timeList"]
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
    var id: Int64 = 0
    var zikir: String = ""
    var aciklamasi: String = ""
    var kaynak: String = ""
    var deletable: Bool = false
 
    
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        zikir <- map["zikir"]
        aciklamasi <- map["aciklamasi"]
        kaynak <- map["kaynak"]
        deletable <- map["deletable"]

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

class SelectZikir: NSObject,Mappable,Codable {
    var id: Int64 = 0
    var count: Int64 = 0
    var zikir: String = ""
    var isSelected: Bool = false
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
       
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        count <- map["count"]
        zikir <- map["zikir"]
        isSelected <- map["isSelected"]
    }
}







