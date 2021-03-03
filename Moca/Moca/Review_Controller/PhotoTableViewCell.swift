//
//  TestTableViewCell.swift
//  main
//
//  Created by Ria Song on 2021/02/27.
//

import UIKit
import Cosmos

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet var lbl_name: UILabel!
    @IBOutlet var ratingStar: CosmosView!
    @IBOutlet var lbl_date: UILabel!
    @IBOutlet var iv_img: UIImageView!
    @IBOutlet var tv_content: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        ratingStar.settings.fillMode = .half

        iv_img!.layer.cornerRadius = iv_img!.frame.height/4
        iv_img!.layer.cornerRadius = 20
        iv_img!.layer.borderWidth = 1
        iv_img!.layer.borderColor = UIColor.clear.cgColor
        // 뷰의 경계에 맞춰준다
        iv_img!.clipsToBounds = true
        // Configure the view for the selected state
    }

}
