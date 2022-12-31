//
//  SettingsViewCell.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 7.03.2022.
//

import UIKit

protocol SettingsDelegate: class {
    func setFavorite(_ selected: Bool, _ index: Int)
    func toTrash(_ selected: Bool, _ index: Int)
}

typealias SettingsClickHandler = (Bool,Int) -> Void

class SettingsViewCell: UITableViewCell {
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var imageSelected: UIImageView!
    @IBOutlet weak var labelLocation: UILabel!
    weak var delegate: SettingsDelegate?
    var favoritedHandler: SettingsClickHandler?
    var trashHandler: SettingsClickHandler?
    var index:Int = 0
    var data: UserInfo? {
        didSet {
            guard let data = data else { return }
            let location = data.uniqName.components(separatedBy: ",")
            let city    = location[0]
            let district = location[1]
            if city == district {
                labelLocation.text = district
            } else {
                labelLocation.text = data.uniqName
            }
            
            
            if data.isFavorite {
                imageSelected.image = UIImage(systemName: "star.fill")
            } else {
                imageSelected.image = UIImage(systemName: "star")
            }
            
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderView.setViewBorder(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func buttonTrashAction(_ sender: Any) {
        delegate?.toTrash(true, index)
    }
    @IBAction func buttonSelectAction(_ sender: Any) {
        guard let data = data else { return }
//        delegate?.setFavorite(!data.isFavorite)
//        data.isFavorite = !data.isFavorite
        favoritedHandler?(data.isFavorite, index)
    }
}
