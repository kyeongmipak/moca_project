//
//  LikeTableViewCell.swift
//  Moca
//
//  Created by JiEunPark on 2021/02/26.
//

import UIKit

// 1 >Create protocolo
protocol LikeCellDelegate {
    func likeDeleteTapped(cell: LikeTableViewCell)
}


class LikeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var likeBrand: UILabel!
    @IBOutlet weak var likeName: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    // 숨길것
    @IBOutlet weak var menuNO: UILabel!
    
    @IBOutlet weak var btnLike: UIButton!
    
    var delegate: LikeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func btnLikeDelete(_ sender: UIButton) {
        //8 > set this condition and call your proto func
            delegate?.likeDeleteTapped(cell: self)
    }
}
