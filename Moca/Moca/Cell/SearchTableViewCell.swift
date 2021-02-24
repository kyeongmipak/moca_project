//
//  SearchTableViewCell.swift
//  Moca
//
//  Created by 박경미 on 2021/02/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchImgView: UIImageView!
    @IBOutlet weak var brandNameLbl: UILabel!
    @IBOutlet weak var menuNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
