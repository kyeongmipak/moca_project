//
//  TestTableViewCell.swift
//  main
//
//  Created by Ria Song on 2021/02/27.
//

import UIKit
import Cosmos

protocol PhotoTableViewCellDelegate: class {
  func customCell(_ customCell: PhotoTableViewCell, btn_ReportAction button: UIButton)
}

class PhotoTableViewCell: UITableViewCell {
    
    weak var delegate: PhotoTableViewCellDelegate?
    
    @IBOutlet var lbl_name: UILabel!
    @IBOutlet var ratingStar: CosmosView!
    @IBOutlet var lbl_date: UILabel!
    @IBOutlet var iv_img: UIImageView!
    @IBOutlet var tv_content: UITextView!
    @IBOutlet var btn_Report: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iv_img.layer.cornerRadius = iv_img.frame.height/2
        iv_img.layer.cornerRadius = 20
        iv_img.layer.borderWidth = 1
        iv_img.layer.borderColor = UIColor.clear.cgColor
        // 뷰의 경계에 맞춰준다
        iv_img.clipsToBounds = true
        // Configure the view for the selected state
    }
    
    
    @IBAction func btn_ReportAction(_ sender: UIButton) {
        delegate?.customCell(self, btn_ReportAction: sender)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        ratingStar.settings.fillMode = .half

    }
    
}
