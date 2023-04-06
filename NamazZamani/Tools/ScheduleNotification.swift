//
//  ScheduleNotification.swift
//  NamazZamani
//
//  Created by Süha Karakaya on 26.03.2023.
//

import Foundation
import UserNotifications


class ScheduleNotification {
    
    
    static func fetchNotify(timeList: LocationDetail, completion: @escaping (Bool) -> Void){
        
        
        if let data = UserDefaults.standard.data(forKey: "notify") {
            do {
                let decoder = JSONDecoder()
                let encoder = JSONEncoder()
                
                var notify = try decoder.decode(Notification.self, from: data)
                
                if notify.sabahSelected {
                    cleanAndScheduleNotify(mv: notify.repeatValue, tL: notify.timeLang, list: notify.sabahNotfyList, timeList: timeList, vakit: "Sabah") { list, finish in
                        notify.sabahNotfyList = []
                        notify.sabahNotfyList = list
                    }
                }
                
                if notify.ogleSelected {
                    cleanAndScheduleNotify(mv: notify.repeatValue, tL: notify.timeLang, list: notify.ogleNotfyList, timeList: timeList, vakit: "Öğle") { list, finish in
                        notify.ogleNotfyList = []
                        notify.ogleNotfyList = list
                    }
                }
                
                if notify.ikindiSelected {
                    cleanAndScheduleNotify(mv: notify.repeatValue, tL: notify.timeLang, list: notify.ikindiNotfyList, timeList: timeList, vakit: "İkindi") { list, finish in
                        notify.ikindiNotfyList = []
                        notify.ikindiNotfyList = list
                    }
                }
                
                if notify.aksamSelected {
                    cleanAndScheduleNotify(mv: notify.repeatValue, tL: notify.timeLang, list: notify.aksamNotfyList, timeList: timeList, vakit: "Akşam") { list, finish in
                        notify.aksamNotfyList = []
                        notify.aksamNotfyList = list
                    }
                }
                
                if notify.yatsiSelected {
                    cleanAndScheduleNotify(mv: notify.repeatValue, tL: notify.timeLang, list: notify.yatsiNotfyList, timeList: timeList, vakit: "Yatsı") { list, finish in
                        notify.yatsiNotfyList = []
                        notify.yatsiNotfyList = list
                    }
                }
                
                let data = try encoder.encode(notify)
                UserDefaults.standard.set(data, forKey: "notify")
                completion(true)
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
    
    private static func cleanAndScheduleNotify(mv: Int, tL: Int, list: [String], timeList: LocationDetail, vakit: String, completion: @escaping ([String], Bool) -> Void){
        var newlist:[String] = []
        MySplashViewController.notificationCenter.removePendingNotificationRequests(withIdentifiers: list)
        MySplashViewController.notificationCenter.removeDeliveredNotifications(withIdentifiers: list)
        var _vakit = ""
        for item in timeList.vakitList.prefix(mv) {
            switch (vakit) {
            case "Sabah":
                _vakit = item.Imsak
                break
            case "Öğle":
                _vakit = item.Ogle
                break
            case "İkindi":
                _vakit = item.Ikindi
                break
            case "Akşam":
                _vakit = item.Aksam
                break
            case "Yatsı":
                _vakit = item.Yatsi
                break
            default:
                break
            }
            
            let sumTime = String(format: "%@ %@", item.MiladiTarihKisa, _vakit)
            let content = UNMutableNotificationContent()
            content.title = "Namaz Vakitleri"
            content.body = "\(vakit) ezanına \(tL) dk kaldı"
            content.sound = UNNotificationSound.default
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
            var someDateTime = formatter.date(from: sumTime)
            someDateTime = someDateTime?.add(minutes: -tL)
            let dateComp = Calendar.current.dateComponents([.year,.month,.day, .hour,.minute], from: someDateTime ?? Date())
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
            let request = UNNotificationRequest(identifier: "\(vakit)-" + DateManager.dateToString3(date: someDateTime ?? Date()), content: content, trigger: trigger)
            newlist.append("\(vakit)-" + DateManager.dateToString3(date: someDateTime ?? Date()))
            //                debugPrint("**")
            //                debugPrint("\(vakit)-" + DateManager.dateToString3(date: someDateTime ?? Date()))
            //                debugPrint(request.identifier)
            //                debugPrint("**")
            MySplashViewController.notificationCenter.add(request)
        }
        completion(newlist, true)
        
    }
    
    
    
}

extension Date {
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var targetDay: Date
        targetDay = Calendar.current.date(byAdding: .year, value: years, to: self)!
        targetDay = Calendar.current.date(byAdding: .month, value: months, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .day, value: days, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .hour, value: hours, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .minute, value: minutes, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .second, value: seconds, to: targetDay)!
        return targetDay
    }
}


