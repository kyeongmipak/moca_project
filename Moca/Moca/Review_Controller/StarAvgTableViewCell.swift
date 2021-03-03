//
//  testStarAvgTableViewCell.swift
//  main
//
//  Created by Ria Song on 2021/02/28.
//

import UIKit
import Cosmos
import TinyConstraints

class StarAvgTableViewCell: UITableViewCell {

    
    @IBOutlet var cosmos_ratingStarAvg: CosmosView!
    @IBOutlet var lbl_starAvg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        cosmos_ratingStarAvg.settings.fillMode = .precise

        // Configure the view for the selected state
    }

}
