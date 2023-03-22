//
//  ZikirSecTableViewCell.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 30.03.2022.
//

import UIKit

typealias ZikirSecInfoHandler = (ZikirObj) -> Void
typealias ZikirSecTrashHandler = (ZikirObj) -> Void
typealias ZikirSecSelectHandler = (ZikirObj) -> Void

class ZikirSecTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: ZikirSecTableViewCell.self)
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var zikirNameLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var cellData = ZikirObj()
    var infoHandler: ZikirSecInfoHandler?
    var trashHandler: ZikirSecTrashHandler?
    var selectHandler: ZikirSecSelectHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func trashButtonAction(_ sender: Any) {
        trashHandler?(cellData)
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        infoHandler?(cellData)
    }
    @IBAction func zikirSecButtonAction(_ sender: Any) {
        
        selectHandler?(cellData)
    }
    
    @IBAction func customSelectZikirAction(_ sender: Any) {
        if cellData.data.deletable {
            infoHandler?(cellData)
        }
    }
    
    
    func setup(_ data: ZikirObj) {
        cellData = data
        cellView.setViewBorder(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
        zikirNameLabel.text = data.data.zikir
        infoButton.isHidden = data.data.deletable
        trashButton.isHidden = !data.data.deletable
        
        
    }
}
