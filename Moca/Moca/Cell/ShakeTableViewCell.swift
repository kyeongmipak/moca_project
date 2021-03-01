//
//  ShakeTableViewCell.swift
//  Main_FINIALLY_2.26
//
//  Created by 박경미 on 2021/03/01.
//

import UIKit

class ShakeTableViewCell: UITableViewCell {

    @IBOutlet weak var rankMenu: UILabel!
    @IBOutlet weak var imgMenuImage: UIImageView!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblMenuName: UILabel!
    @IBOutlet weak var lblReviewAvg: UILabel!
    @IBOutlet weak var lblMenuPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
