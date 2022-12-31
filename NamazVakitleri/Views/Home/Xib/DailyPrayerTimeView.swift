//
//  DailyPrayerTimeView.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 31.12.2022.
//

import UIKit

class DailyPrayerTimeView: UIView {

    @IBOutlet weak var xibview: UIView!
    @IBOutlet weak var yatsiValueLabel: UILabel!
    @IBOutlet weak var aksamValueLabel: UILabel!
    @IBOutlet weak var ikindiValueLabel: UILabel!
    @IBOutlet weak var ogleValueLabel: UILabel!
    @IBOutlet weak var gunesValueLabel: UILabel!
    @IBOutlet weak var imsakValueLabel: UILabel!
    @IBOutlet weak var yatsiKeyLabel: UILabel!
    @IBOutlet weak var aksamKeyLabel: UILabel!
    @IBOutlet weak var ikindiKeyLabel: UILabel!
    @IBOutlet weak var ogleKeyLabel: UILabel!
    @IBOutlet weak var gunesKeyLabel: UILabel!
    @IBOutlet weak var imsakKeyLabel: UILabel!
    @IBOutlet weak var hicriTimeKeyLabel: UILabel!
    @IBOutlet weak var miladiTimeKeyLabel: UILabel!
    @IBOutlet weak var hicriTimeValueLabel: UILabel!
    @IBOutlet weak var miladiTimeValueLabel: UILabel!
    
    var data: Vakit? = nil {
        didSet {
            guard let data = data else { return }
            miladiTimeValueLabel.text = data.MiladiTarihUzun
            hicriTimeValueLabel.text = data.HicriTarihUzun
            imsakValueLabel.text = data.Imsak
            gunesValueLabel.text = data.Gunes
            ogleValueLabel.text = data.Ogle
            ikindiValueLabel.text = data.Ikindi
            aksamValueLabel.text = data.Aksam
            yatsiValueLabel.text = data.Yatsi
            miladiTimeKeyLabel.text = "Miladi Tarih"
            hicriTimeKeyLabel.text = "Hicri Tarih"
            imsakKeyLabel.text = "İmsak"
            gunesKeyLabel.text = "Güneş"
            ogleKeyLabel.text = "Öğle"
            ikindiKeyLabel.text = "İkindi"
            aksamKeyLabel.text = "Akşam"
            yatsiKeyLabel.text = "Yatsı"
        }
    }
    
    class func instance() -> DailyPrayerTimeView {
            guard let view = UINib(
                nibName: String(describing: self), bundle: nil
            ).instantiate(withOwner: nil, options: nil).first as? DailyPrayerTimeView else {
                fatalError("Could not initalize view")
            }
            view.mysetup()
            return view
        }
    
    
    func mysetup(){
        xibview.setViewBorder(color:  UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
    }

}
