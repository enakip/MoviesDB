//
//  TableViewCellLabelWithImage.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 19.11.2020.
//

import UIKit

class TableViewCellLabelWithImage: UITableViewCell {

    @IBOutlet weak var imageviewProfie : UIImageView!
    @IBOutlet weak var labelMovie : UILabel!
    @IBOutlet weak var labelOriginal : UILabel!
    @IBOutlet weak var viewSeperatr : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewSeperatr.backgroundColor = Colors().banabiColor
        
        self.labelMovie.numberOfLines = 0
        
        self.imageviewProfie.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
