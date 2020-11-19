//
//  CollectionViewCellGrid.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 16.11.2020.
//

import UIKit

class CollectionViewCellGrid: UICollectionViewCell {

    @IBOutlet weak var buttonFavorite : UIButton!
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var imageviewMovie : UIImageView!
    @IBOutlet weak var viewContent : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewContent.layer.cornerRadius = 6.0
        self.viewContent.layer.masksToBounds = true
        
        self.labelTitle.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.labelTitle.textColor = .white
        self.labelTitle.numberOfLines = 0
        self.labelTitle.textAlignment = .center
        
        self.buttonFavorite.setImage(UIImage.init(named: ""), for: .normal)
    }

    func populateCell(model:Result, isFav:Bool) {
        
        APIMethods.init().downloadImage(from: model.poster_path ?? "", imageview: self.imageviewMovie)
        
        self.imageviewMovie.contentMode = .scaleAspectFill
        
        self.labelTitle.text = model.title ?? " "
        
        isFav ? self.buttonFavorite.setImage(UIImage.init(named: "fav"), for: .normal) : self.buttonFavorite.setImage(UIImage.init(named: ""), for: .normal)
        
    }
}
