//
//  CollectionViewCellList.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 19.10.2020.
//

import UIKit

class CollectionViewCellList: UICollectionViewCell {

    @IBOutlet weak var buttonFavorite : UIButton!
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var labelVote : UILabel!
    @IBOutlet weak var labelDate : UILabel!
    @IBOutlet weak var imageviewMovie : UIImageView!
    @IBOutlet weak var viewContent : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imageviewMovie.contentMode = .scaleAspectFit
        
        self.viewContent.backgroundColor = Colors().cellBGColor
        self.viewContent.layer.cornerRadius = 6.0
        self.viewContent.layer.masksToBounds = true
        self.viewContent.layer.borderWidth = 0.5
        self.viewContent.layer.borderColor = Colors().banabiColor.cgColor
        
        self.labelTitle.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.labelTitle.textColor = Colors().banabiColor
        self.labelTitle.numberOfLines = 0
        
        self.labelDate.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.labelDate.textColor = Colors().banabiColor
        
        self.labelVote.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.labelVote.textColor = Colors().banabiColor
        
        self.buttonFavorite.setImage(UIImage.init(named: ""), for: .normal)
    }
    
    func populateCell(model:Result, isFav:Bool) {
        
        APIMethods.init().downloadImage(from: model.poster_path ?? "", imageview: self.imageviewMovie)
        
        self.imageviewMovie.contentMode = .scaleAspectFill
        
        self.labelTitle.text = model.title ?? " "
        
        self.labelVote.text = String(model.vote_average ?? 0.0)
        
        self.labelDate.text = (model.release_date ?? "").convertMyDateFormat()
        
        isFav ? self.buttonFavorite.setImage(UIImage.init(named: "fav"), for: .normal) : self.buttonFavorite.setImage(UIImage.init(named: ""), for: .normal)
        
    }
    
}
