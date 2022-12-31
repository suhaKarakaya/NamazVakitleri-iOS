//
//  DateManager.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 3.03.2022.
//

import Foundation

class DateManager {
    
    static let shared = DateManager()
        
    init(){}
        
    func getTodayString() -> String{
        let date = Date()
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)

        return today_string
    }
    
    static func dateToString1(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.string(from: date)
    }
    
    static func dateToString2(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        return dateFormatter.string(from: date)
    }
    
    
    static func dateToStringUgur(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        return dateFormatter.string(from: date)
    }
    
    
    static func strToDate1(strDate: String) -> Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMMM yyyy eeee"
//        return dateFormatter.date(from: strDate)!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "tr_TR") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "dd MMMM yyyy eeee"
        return dateFormatter.date(from:strDate) ?? Date()
    }
    
    static func strToDate2(strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: strDate)?.localDate() ?? Date().localDate()
    }
    
    static func strToDateUgur(strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        return dateFormatter.date(from: strDate) ?? Date()
    }
    
    static func strToDateSuha(strDate: String) -> Date {
        let tempTime = String(format: "%@.%@.%@", strDate.components(separatedBy: ".")[2],strDate.components(separatedBy: ".")[1],strDate.components(separatedBy: ".")[0])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        return dateFormatter.date(from: tempTime) ?? Date()
    }
    
    static func getStrToTimeInterval(strDate: String, strTime:String) -> TimeInterval {
        let tempTime = strTime.components(separatedBy: ":")
        let hour    = tempTime[0]
        let minute = tempTime[1]
        
        let tempDate = strDate.components(separatedBy: ".")
        let day    = tempDate[0]
        let month = tempDate[1]
        let year = tempDate[2]
        
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let now = Date()
        var components = gregorian.components([.year, .month, .day, .hour, .minute], from: now)
    
        components.hour = Int(hour)
        components.minute = Int(minute)
        components.day = Int(day)
        components.month = Int(month)
        components.year = Int(year)
        
        var time = gregorian.date(from: components)!
//        time = time.addingTimeInterval(TimeInterval(30.0 * 60.0 * 6.0))

        return time.timeIntervalSince1970
    }
    
    static func getTimeIntervalToDate(time: TimeInterval) -> String {
        var tempTime = TimeInterval(time)
        let myDate = NSDate(timeIntervalSince1970: tempTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "TR")
        dateFormatter.timeZone = TimeZone(identifier: "TR")
        dateFormatter.dateFormat = "dd.MM.YY HH:mm"
        return dateFormatter.string(from: myDate as Date)
    }
    
    static func stringFromTimeInterval(interval: TimeInterval) -> String {

      let ti = NSInteger(interval)
        let ms = Int(interval.truncatingRemainder(dividingBy: 1) * 1000)

      let seconds = ti % 60
      let minutes = (ti / 60) % 60
      let hours = (ti / 3600)

      return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
    static func checkSuhaDate(date: Date, endDate: Date) -> Bool {
        var strDate = dateToStringUgur(date: date)
        var strEndDate = dateToStringUgur(date: endDate)
        return strDate.elementsEqual(strEndDate)
    }
    
    
    
    static func checkDate(date: Date, endDate: Date) -> ComparisonResult {
            let calendar = Calendar.current;
            let components:Set<Calendar.Component> = [.day, .month, .year];
            let date1Components = calendar.dateComponents(components, from: date);
            let date2Components = calendar.dateComponents(components, from: endDate);

            let firstDate = calendar.date(from: date1Components);
            let secondDate = calendar.date(from: date2Components);

            let result:ComparisonResult = secondDate!.compare(firstDate!);
            switch result {
            case .orderedAscending:
                debugPrint(String(format: "%@ is in future from %@", date as CVarArg,endDate as CVarArg));
                break;
            case .orderedDescending:
                debugPrint(String(format: "%@ is in past from %@", date as CVarArg,endDate as CVarArg));
                break;
            case .orderedSame:
                debugPrint(String(format: "%@ is in same as %@", date as CVarArg,endDate as CVarArg));
                break;
            default:
                debugPrint(String(format: "erorr dates %@, %@", date as CVarArg,endDate as CVarArg));
                break;
            }

            return result;

        }
    
 
}


