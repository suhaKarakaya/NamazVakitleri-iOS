//
//  SettingsViewCell.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 7.03.2022.
//

import UIKit

protocol SettingsDelegate: class {
    func setFavorite(_ selected: Bool)
    func toTrash(_ selected: Bool)
}

typealias SettingsClickHandler = (Bool) -> Void

class SettingsViewCell: UITableViewCell {
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var imageSelected: UIImageView!
    @IBOutlet weak var labelLocation: UILabel!
    weak var delegate: SettingsDelegate?
    var favoritedHandler: SettingsClickHandler?
    var trashHandler: SettingsClickHandler?
    var data: FavoriteLocations? {
        didSet {
            guard let data = data else { return }
            labelLocation.text = data.location["location"] as? String ?? ""
            
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
        borderView.layer.borderColor = UIColor.brown.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 8
  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonTrashAction(_ sender: Any) {
        delegate?.toTrash(true)
    }
    @IBAction func buttonSelectAction(_ sender: Any) {
        guard let data = data else { return }
//        delegate?.setFavorite(!data.isFavorite)
        favoritedHandler?(!data.isFavorite)
    }
}
