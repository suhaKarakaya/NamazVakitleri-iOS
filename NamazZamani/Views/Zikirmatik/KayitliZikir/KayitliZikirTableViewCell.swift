//
//  KayitliZikirTableViewCell.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 31.03.2022.
//

import UIKit
//
typealias KayitliZikirSecTrashHandler = (ZikirObj) -> Void
typealias KayitliZikirSelectHandler = (ZikirObj) -> Void
typealias KayitliZikirViewHandler = (ZikirObj) -> Void

class KayitliZikirTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: KayitliZikirTableViewCell.self)
    
    @IBOutlet weak var viewSelectedPoint: UIView!
    @IBOutlet weak var zikirSelectedButton: UIButton!
    @IBOutlet weak var zikirNameLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var cellData = ZikirObj()
    var index = 0
    var trashHandler: KayitliZikirSecTrashHandler?
    var selectHandler: KayitliZikirSelectHandler?
    var viewZikrHandler: KayitliZikirViewHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup(_ data: ZikirObj) {
        cellData = data
        cellView.setViewBorder(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
        zikirNameLabel.text = String(data.data.zikir)
        zikirSelectedButton.setTitle(String(data.data.count), for: .normal)
        if cellData.data.isSelected {
            self.viewSelectedPoint.isHidden = false
            self.viewSelectedPoint.backgroundColor = UIColor(named: "kabeYellow")
            self.viewSelectedPoint.layer.cornerRadius = self.viewSelectedPoint.frame.size.width/2
        } else {
            self.viewSelectedPoint.isHidden = true
        }
        
    }
    
    @IBAction func trashButtonAction(_ sender: Any) {
        trashHandler?(cellData)
    }
    @IBAction func zikirSelectedButtonAction(_ sender: Any) {
        selectHandler?(cellData)
    }
    @IBAction func zikirViewButtonAction(_ sender: Any) {
        viewZikrHandler?(cellData)
    }
    
}
