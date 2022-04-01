//
//  ZikirSecTableViewCell.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 30.03.2022.
//

import UIKit

typealias ZikirSecInfoHandler = (String,String) -> Void
typealias ZikirSecTrashHandler = (Int) -> Void
typealias ZikirSecSelectHandler = (Zikir) -> Void

class ZikirSecTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: ZikirSecTableViewCell.self)
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var zikirNameLabel: UILabel!
    @IBOutlet weak var zikirIndexLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var data = Zikir()
    var index = 0
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
        trashHandler?(index)
    }
    
    @IBAction func infoButtonAction(_ sender: Any) {
        infoHandler?(data.zikir,String(format: "%@\n%@%@", data.aciklamasi,"Kaynak: ", data.kaynak))
    }
    @IBAction func zikirSecButtonAction(_ sender: Any) {
        
        selectHandler?(data)
    }
    
    func setup(_ data: Zikir) {
        self.data = data
        cellView.setViewBorder(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
        zikirIndexLabel.text = String(data.id)
        zikirNameLabel.text = data.zikir
        infoButton.isHidden = data.deletable
        trashButton.isHidden = !data.deletable

   
    }
}
