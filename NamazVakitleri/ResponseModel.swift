//
//  Country.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 16.02.2022.
//

import Foundation
import ObjectMapper

struct Country: Codable {
    let UlkeAdi: String?
    let UlkeAdiEn: String?
    let UlkeID: String?
}

struct City: Codable {
    let SehirAdi: String?
    let SehirAdiEn: String?
    let SehirID: String?
}

struct District: Codable {
    let IlceAdi: String?
    let IlceAdiEn: String?
    let IlceID: String?
}

class Vakit: Mappable,Codable {
    var Aksam: String?
    var Gunes: String?
    var GunesBatis: String?
    var GunesDogus: String?
    var HicriTarihKisa: String?
    var HicriTarihUzun: String?
    var Ikindi: String?
    var Imsak: String?
    var KibleSaati: String?
    var MiladiTarihKisa: String?
    var MiladiTarihUzun: String?
    var Ogle: String?
    var Yatsi: String?
    
    required init(map: Map) {
        
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

struct VakitStr: Codable {
    let Aksam: String?
    let Gunes: String?
    let GunesBatis: String?
    let GunesDogus: String?
    let HicriTarihKisa: String?
    let HicriTarihUzun: String?
    let Ikindi: String?
    let Imsak: String?
    let KibleSaati: String?
    let MiladiTarihKisa: String?
    let MiladiTarihUzun: String?
    let Ogle: String?
    let Yatsi: String?
}





