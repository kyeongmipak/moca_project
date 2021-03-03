//
//  TestTextOnlyTableViewCell.swift
//  main
//
//  Created by Ria Song on 2021/03/02.
//

import UIKit
import Cosmos
import TinyConstraints

class TextOnlyTableViewCell: UITableViewCell {

    
    @IBOutlet var lbl_userNickname: UILabel!
    @IBOutlet var ratingStar: CosmosView!
    @IBOutlet var tv_reviewContent: UITextView!
    @IBOutlet var lbl_reviewInsertDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        ratingStar.settings.fillMode = .half
    }

}
