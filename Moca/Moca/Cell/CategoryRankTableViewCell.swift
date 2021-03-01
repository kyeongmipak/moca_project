//
//  CategoryRankTableViewCell.swift
//  Moca
//
//  Created by 박경미 on 2021/03/01.
//

import UIKit

protocol CategoryRankTableViewCellDelegate {
    func categorySelectedInfoBtn(category: String)
}

class CategoryRankTableViewCell: UITableViewCell {

    @IBOutlet weak var btnCategoryRank: UIButton!
    
    var delegate: CategoryRankTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnCategoryRankMove(_ sender: UIButton) {
        self.delegate?.categorySelectedInfoBtn(category: "")

    }
}
