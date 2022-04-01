//
//  Home.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 28.03.2022.
//

import Foundation

class HomeScreen {
    var location: String
    var miladiTimeKisa: String
    var miladiTimeUzun: String
    var hicriTime: String
    var remainingTime: String
    var imsakTime: String
    var gunesTime: String
    var ogleTime: String
    var ikindiTime: String
    var aksamTime: String
    var yatsiTime: String
    var nextDay: String
    var nextDayImsakTime: String
    
    init(
         location: String = "",
         miladiTimeKisa: String = "",
         miladiTimeUzun: String = "",
         hicriTime: String = "",
         remainingTime: String = "",
         imsakTime: String = "",
         gunesTime: String = "",
         ogleTime: String = "",
         ikindiTime: String = "",
         aksamTime: String = "",
         yatsiTime: String = "",
         nextDay: String = "",
         nextDayImsakTime: String = ""
          
          ) {
              self.location = location
              self.miladiTimeKisa = miladiTimeKisa
              self.miladiTimeUzun = miladiTimeUzun
              self.hicriTime = hicriTime
              self.remainingTime = remainingTime
              self.imsakTime = imsakTime
              self.gunesTime = gunesTime
              self.ogleTime = ogleTime
              self.ikindiTime = ikindiTime
              self.aksamTime = aksamTime
              self.yatsiTime = yatsiTime
              self.nextDay = nextDay
              self.nextDayImsakTime = nextDayImsakTime
     }
    

}
