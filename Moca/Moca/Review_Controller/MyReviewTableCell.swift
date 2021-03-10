//
//  MyReviewTableCell.swift
//  main
//
//  Created by Ria Song on 2021/03/02.
//

import UIKit
import Cosmos
import TinyConstraints

class MyReviewTableCell: UITableViewCell {
    

    @IBOutlet var lbl_reviewDate: UILabel!
    @IBOutlet var ratingStar: CosmosView!
    @IBOutlet var lbl_menuName: UILabel!
    @IBOutlet var lbl_brandName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        ratingStar.settings.fillMode = .half
    }

}
