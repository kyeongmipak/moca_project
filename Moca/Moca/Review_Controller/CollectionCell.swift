//
//  testCollectionCell.swift
//  main
//
//  Created by Ria Song on 2021/02/27.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet var iv_testImg: UIImageView!
    
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
        
//        self.iv_testImg.layer.cornerRadius = self.iv_testImg.frame.height/2
//        self.iv_testImg.layer.borderWidth = 1
//        self.iv_testImg.layer.borderColor = UIColor.clear.cgColor
//        // 뷰의 경계에 맞춰준다
//        self.iv_testImg.clipsToBounds = true
        //        iv_testImg.layer.cornerRadius = iv_testImg.frame.width/10
        //        iv_testImg.clipsToBounds = true
        //
        //        iv_testImg.backgroundColor = UIColor.white
        //        iv_testImg.layer.cornerRadius = 8.0
        //        iv_testImg.clipsToBounds = true
        
    }
}


