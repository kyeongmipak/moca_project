//
//  DetailButtonTableViewCell.swift
//  Moca
//
//  Created by 박경미 on 2021/03/06.
//

import UIKit

protocol DetailButtonTableViewCellDelegate {
    func selectedInfoBtn(action: String)
}

class DetailButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    
    var delegate: DetailButtonTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeBtnAction(_ sender: UIButton) {
        self.delegate?.selectedInfoBtn(action: "like")
    }
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        self.delegate?.selectedInfoBtn(action: "share")
    }
    
    @IBAction func mapBtnAction(_ sender: UIButton) {
        self.delegate?.selectedInfoBtn(action: "map")
    }
}
