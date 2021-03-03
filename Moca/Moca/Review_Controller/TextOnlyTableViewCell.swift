//
//  TestTextOnlyTableViewCell.swift
//  main
//
//  Created by Ria Song on 2021/03/02.
//

import UIKit
import Cosmos
import TinyConstraints

protocol TextOnlyTableViewCellDelegate: class {
  func customCell(_ customCell: TextOnlyTableViewCell, btn_ReportAction2 button: UIButton)
}

class TextOnlyTableViewCell: UITableViewCell {
    
    weak var delegate: TextOnlyTableViewCellDelegate?

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

    @IBAction func btn_ReportAction2(_ sender: UIButton) {
        delegate?.customCell(self, btn_ReportAction2: sender)
    }
    
    
    
} // END
