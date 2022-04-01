//
//  KayitliZikirTableViewCell.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 31.03.2022.
//

import UIKit

typealias KayitliZikirSecTrashHandler = (Int) -> Void
typealias KayitliZikirSelectHandler = (Int) -> Void

class KayitliZikirTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: KayitliZikirTableViewCell.self)

    @IBOutlet weak var zikirSelectedButton: UIButton!
    @IBOutlet weak var zikirNameLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var data = SelectZikir()
    var index = 0
    var trashHandler: KayitliZikirSecTrashHandler?
    var selectHandler: KayitliZikirSelectHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ data: SelectZikir) {
        self.data = data
        cellView.setViewBorder(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
        zikirNameLabel.text = String(data.zikir)
        zikirSelectedButton.setTitle(String(data.count), for: .normal)
 
    }
    
    @IBAction func trashButtonAction(_ sender: Any) {
        trashHandler?(index)
    }
    @IBAction func zikirSelectedButtonAction(_ sender: Any) {
        selectHandler?(index)
    }
    
}
