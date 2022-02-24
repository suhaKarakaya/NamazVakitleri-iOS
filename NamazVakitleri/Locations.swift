//
//  Locations.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 18.02.2022.
//

import Foundation
import ObjectMapper

class Locations: Mappable {
    var blabla: String?
    var oley: String?
    
    required init(map: Map) {
        
    }
    
    func mapping(map: Map) {
        oley <- map["oley"]
        blabla <- map["blabla"]

   }
   
}
