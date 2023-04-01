//
//  NotificationViewController.swift
//  NamazZamani
//
//  Created by Süha Karakaya on 25.03.2023.
//

import UIKit

class NotificationViewController: UIViewController {
    
    
    @IBOutlet weak var switchYatsi: UISwitch!
    @IBOutlet weak var switchAksam: UISwitch!
    @IBOutlet weak var switchIkindi: UISwitch!
    @IBOutlet weak var switchOgle: UISwitch!
    @IBOutlet weak var switchSabah: UISwitch!
    
    var notify = Notification()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MySplashViewController.notificationCenter.getPendingNotificationRequests { se in
            se.forEach { re in
                debugPrint(re.identifier)
            }
        }
        if let data = UserDefaults.standard.data(forKey: "notify") {
            do {
                notify = try decoder.decode(Notification.self, from: data)
                switchSabah.isOn = !notify.sabahNotfyList.isEmpty
                switchOgle.isOn = !notify.ogleNotfyList.isEmpty
                switchIkindi.isOn = !notify.ikindiNotfyList.isEmpty
                switchAksam.isOn = !notify.aksamNotfyList.isEmpty
                switchYatsi.isOn = !notify.yatsiNotfyList.isEmpty
                
            } catch {
                print("Unable to Decode Note (\(error))")
            }
        } else {
            switchSabah.isOn = false
            switchOgle.isOn = false
            switchIkindi.isOn = false
            switchAksam.isOn = false
            switchYatsi.isOn = false
        }
        
        
    }
    
    
    
    @IBAction func btnApplyAction(_ sender: Any) {
        MySplashViewController.notificationCenter.requestAuthorization(options: [.alert, .sound]) { (permissionGranted, error) in
            
            if !permissionGranted {
                debugPrint("permission denied")
            } else {
                DispatchQueue.main.async {
                    
                    var count = 5
                    if !self.switchSabah.isOn {
                        self.notify.sabahNotfyList = []
                        count -= 1
                        self.notify.sabahSelected = false
                    } else {
                        self.notify.sabahSelected = true
                    }
                    if !self.switchOgle.isOn {
                        self.notify.ogleNotfyList = []
                        count -= 1
                        self.notify.ogleSelected = false
                    } else {
                        self.notify.ogleSelected = true
                    }
                    if !self.switchIkindi.isOn {
                        self.notify.ikindiNotfyList = []
                        count -= 1
                        self.notify.ikindiSelected = false
                    } else {
                        self.notify.ikindiSelected = true
                    }
                    if !self.switchAksam.isOn {
                        self.notify.aksamNotfyList = []
                        count -= 1
                        self.notify.aksamSelected = false
                    } else {
                        self.notify.aksamSelected = true
                    }
                    if !self.switchYatsi.isOn {
                        self.notify.yatsiNotfyList = []
                        count -= 1
                        self.notify.yatsiSelected = false
                    } else {
                        self.notify.yatsiSelected = true
                    }
                    
                    self.notify.repeatValue = 64 / count
                    
                    do {
                        let data = try self.encoder.encode(self.notify)
                        UserDefaults.standard.set(data, forKey: "notify")
                    } catch {
                        print("Unable to Decode Note (\(error))")
                    }
                    
                    PrayerTimeOrganize.getMyLocationData { data, result in
                        if result {
                            ScheduleNotification.fetchNotify(timeList: data) { finish in
                                if finish {}
                            }
                        }
                    }
                }  
            }
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func btnTimeScheduleAction(_ sender: Any) {
    }
}
