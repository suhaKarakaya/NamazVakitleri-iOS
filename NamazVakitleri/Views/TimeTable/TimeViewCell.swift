//
//  TimeViewCell.swift
//  NamazVakitleri
//
//  Created by Süha Karakaya on 5.03.2022.
//

import UIKit

class TimeViewCell: UITableViewCell {

    @IBOutlet weak var labelYatsiValue: UILabel!
    @IBOutlet weak var labelYatsiKey: UILabel!
    @IBOutlet weak var labelAksamValue: UILabel!
    @IBOutlet weak var labelAksamKey: UILabel!
    @IBOutlet weak var labelIkindiValue: UILabel!
    @IBOutlet weak var labelIkindiKey: UILabel!
    @IBOutlet weak var labelOgleValue: UILabel!
    @IBOutlet weak var labelOgleKey: UILabel!
    @IBOutlet weak var labelGunesValue: UILabel!
    @IBOutlet weak var labelGunesKey: UILabel!
    @IBOutlet weak var labelImsakValue: UILabel!
    @IBOutlet weak var labelImsakKey: UILabel!
    @IBOutlet weak var labelHicriTarihValue: UILabel!
    @IBOutlet weak var labelHicriTarihKey: UILabel!
    @IBOutlet weak var labelMiladiTarihValue: UILabel!
    @IBOutlet weak var labelMiladiTarihKey: UILabel!
    @IBOutlet weak var viewStack: UIStackView!
    
      
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewStack.setViewBorder(color: UIColor.brown.cgColor, borderWith: 1, borderRadius: 8)
        
    
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
