//
//  TableViewCellLabel.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 18.11.2020.
//

import UIKit

class TableViewCellLabel: UITableViewCell {

    @IBOutlet weak var label : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.label.numberOfLines = 0
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
