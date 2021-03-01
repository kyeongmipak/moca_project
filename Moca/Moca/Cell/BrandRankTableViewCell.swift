//
//  BrandRankTableViewCell.swift
//  Moca
//
//  Created by 박경미 on 2021/03/01.
//

import UIKit

protocol BrandRankTableViewCellDelegate {
    func selectedInfoBtn(name: String)
}

class BrandRankTableViewCell: UITableViewCell {

    @IBOutlet weak var btnStarbucks: UIButton!
    @IBOutlet weak var btnEdiya: UIButton!
    @IBOutlet weak var btnTwosome: UIButton!
    @IBOutlet weak var btnHollys: UIButton!
    
    var delegate: BrandRankTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnStarbucksMove(_ sender: UIButton) {
        self.delegate?.selectedInfoBtn(name: "스타벅스")
    }
    
    @IBAction func btnEdiyaMove(_ sender: UIButton) {
        self.delegate?.selectedInfoBtn(name: "이디야")
    }
    
    @IBAction func btnTwosomeMove(_ sender: UIButton) {
        self.delegate?.selectedInfoBtn(name: "투썸플레이스")
    }
    @IBAction func btnHollysMove(_ sender: UIButton) {
        self.delegate?.selectedInfoBtn(name: "할리스")
    }
}
