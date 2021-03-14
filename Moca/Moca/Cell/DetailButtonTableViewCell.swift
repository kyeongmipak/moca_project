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

class DetailButtonTableViewCell: UITableViewCell, LikeCountJsonModelProtocol {
    
    @IBOutlet weak var LikeImg: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet var writeReviewBtn: UIButton!
    
    var delegate: DetailButtonTableViewCellDelegate?
    
    var result = 3
    
    var menuNo = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if Share.userEmail == "" {
            LikeImg.isHidden = true
            writeReviewBtn.isHidden = true
        }else {
            LikeImg.isHidden = false
            writeReviewBtn.isHidden = false
        }
        
        
        
        
        let likejsonModel = LikeCountJsonModel()
        likejsonModel.delegate = self
        likejsonModel.downloadItems(userInfo_userEmail: Share.userEmail, menu_menuNO: menuNo)
        
        // 이미지뷰를 터치했을때 이벤트 주기 +++++++++++++++++
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchToStar))
        LikeImg.addGestureRecognizer(tapGesture)
        LikeImg.isUserInteractionEnabled = true
        // ++++++++++++++++++++++++++++++++++++++++
        
        print("jieun menuNO : \(menuNo)")
    }
    
    func reloadData() {
        
        let likejsonModel = LikeCountJsonModel()
        likejsonModel.delegate = self
        likejsonModel.downloadItems(userInfo_userEmail: Share.userEmail, menu_menuNO: menuNo)
    }
    
    @objc func touchToStar(sender: UITapGestureRecognizer) {
        
        if (sender.state == .ended) {
            //
            if LikeImg.image == UIImage(named: "yes_like.png") {
                print("해지")
                LikeImg.image = UIImage(named: "no_like.png")
                let likeDeleteModel = LikeDeleteModel() // instance 선언
                let result_Delete = likeDeleteModel.likeDeleteItems(menuNO: menuNo)
            }else{
                print("등록")
                LikeImg.image = UIImage(named: "yes_like.png")
                
                let likeInsertModel = LikeInsertModel() // instance 선언
                let result_Insert = likeInsertModel.likeInsertItems(userInfo_userEmail: Share.userEmail, menu_menuNo: menuNo)
            }
            
        }
        
    }
    
    func likeItemDownloaded(items: Int) {
        result = items
        print(result)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func shareBtnAction(_ sender: UIButton) {
        self.delegate?.selectedInfoBtn(action: "share")
    }
    
    @IBAction func mapBtnAction(_ sender: UIButton) {
        self.delegate?.selectedInfoBtn(action: "map")
    }
    
    @IBAction func writeReviewBtnAction(_ sender: UIButton) {
        self.delegate?.selectedInfoBtn(action: "writeReview")
    }
    
}
