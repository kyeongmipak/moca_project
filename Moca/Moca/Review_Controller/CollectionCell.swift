//
//  testCollectionCell.swift
//  main
//
//  Created by Ria Song on 2021/02/27.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet var iv_testImg: UIImageView!
    @IBOutlet var lbl_NonReviewCollection: UILabel!
    
    var cellImageName:String?
    class var CustomCell : CollectionCell {
        let cell = Bundle.main.loadNibNamed("CollectionCell", owner: self, options: nil)?.last
        return cell as! CollectionCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.red
        
    }
    
    func updateCellWithImage(name:String) {
        self.cellImageName = name
        self.iv_testImg.image = UIImage(named: name)
            
    }
}


