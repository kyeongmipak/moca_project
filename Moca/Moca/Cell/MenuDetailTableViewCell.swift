//
//  MenuDetailTableViewCell.swift
//  Moca
//
//  Created by 박경미 on 2021/03/06.
//

import UIKit

class MenuDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuBrandName: UILabel!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var menuPriceCal: UILabel!
    @IBOutlet weak var menuContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
