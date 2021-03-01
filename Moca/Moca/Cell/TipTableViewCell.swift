//
//  TipTableViewCell.swift
//  Moca
//
//  Created by 박경미 on 2021/03/01.
//

import UIKit

protocol TipTableViewCellDelegate {
    func selectedInfoBtn()
}

class TipTableViewCell: UITableViewCell {

    @IBOutlet weak var btnTip: UIButton!
    
    var index: Int = 0
    var delegate: TipTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnAdminTip(_ sender: UIButton) {
        self.delegate?.selectedInfoBtn()
    
    }
    
}
