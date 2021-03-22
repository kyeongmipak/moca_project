//
//  WriteReviewController.swift
//  main
//
//  Created by Ria Song on 2021/02/25.
//

import UIKit
import Cosmos
import TinyConstraints

class WriteReviewController: UIViewController, UIImagePickerControllerDelegate & UITextViewDelegate, UINavigationControllerDelegate  {
    
    // MARK: - 변수 Setting
    @IBOutlet var lbl_userNickname: UILabel! // readOnly
    @IBOutlet var tv_reviewContent: UITextView!
    @IBOutlet var lbl_nonPhoto: UILabel!
    @IBOutlet var lbl_notice: UITextView!
    @IBOutlet var reviewRatingStar: CosmosView!
    @IBOutlet var lbl_brandName: UILabel!
    @IBOutlet var lbl_MenuName: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    // UIImagePickerController 객체 생성
    let imagePickerController = UIImagePickerController()
    var InfoItem = [String]()
    var imageURL: URL?
    var check = 0
    var rate :Double = Double()
    var tempStar = ""

    
    // 아무곳이나 눌러 softkeyboard 지우기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_brandName.text = InfoItem[0]
        lbl_MenuName.text = InfoItem[1]
        
        lbl_nonPhoto.text = "사진을 첨부해주세요."
        imagePickerController.delegate = self
        
        //Cosmos setting
        reviewRatingStar.settings.totalStars = 5 // max = 5
        reviewRatingStar.settings.fillMode = .half
        
        reviewRatingStar.didTouchCosmos = {
            rating in
            self.rate = rating
            print(rating)
            
            self.tempStar = String(rating)
            print("self.tempStar\(self.tempStar) = rating\(rating)" )
        } // cosmos setting end
        
        // tv placeholder 설정
        tv_reviewContent.delegate = self
        
        tv_reviewContent.text = "내용을 작성해주세요."
        tv_reviewContent.textColor = UIColor.lightGray
        tv_reviewContent.selectedTextRange = tv_reviewContent.textRange(from: tv_reviewContent.beginningOfDocument, to: tv_reviewContent.beginningOfDocument)
        
        // tv 테두리 설정
        tv_reviewContent.layer.borderColor = UIColor.darkGray.cgColor
        tv_reviewContent.layer.cornerRadius = 10
        tv_reviewContent.layer.borderWidth = 0.5
        tv_reviewContent.layer.masksToBounds = true
        
        
        // notice 설정
        let attributedStr = NSMutableAttributedString(string: lbl_notice.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 9
        attributedStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedStr.length))
        lbl_notice.attributedText = attributedStr
        attributedStr.addAttribute(.foregroundColor, value: UIColor.red, range: (lbl_notice.text! as NSString).range(of: "삭제"))
        attributedStr.addAttribute(.foregroundColor, value: UIColor.red, range: (lbl_notice.text! as NSString).range(of: "수정"))
        attributedStr.addAttribute(.foregroundColor, value: UIColor.blue, range: (lbl_notice.text! as NSString).range(of: "마이페이지 → 나의 리뷰"))

        
        // 설정이 적용된 text를 label의 attributedText에 저장
        lbl_notice.attributedText = attributedStr
        
    } // viewDidLoad end
    
    @IBAction func btnPhotoLibrary(_ sender: UIButton){
        
        let photoAlert = UIAlertController(title: "사진 가져오기", message: "앨범에서 사진을 가져 옵니다.", preferredStyle: UIAlertController.Style.actionSheet) // Alert가 화면 밑에서 돌출
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        photoAlert.addAction(okAction)
        photoAlert.addAction(cancelAction)
        
        present(photoAlert, animated: true, completion: nil)
    }
    
    
    @IBAction func btnRegisterReview(_ sender: UIButton) {
        
        let resultAlert = UIAlertController(title: "완료", message: "리뷰가 입력되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
             self.imgUpload()
            
        })
        resultAlert.addAction(onAction)
        present(resultAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgView.image = image
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            check = 1
            lbl_nonPhoto.text = ""
        }
        
        // 켜놓은 앨범 화면 없애기
        dismiss(animated: true, completion: nil)
    }
    
    func imgUpload(){
        let reviewContent = tv_reviewContent.text!
        let reviewStar = tempStar
        let imageUploadModel = ReviewInsertModel()
        let tempMenuNo = InfoItem[2]
        print("imageUpload")
        if check == 1 {
            //            print("imageURL : \(imageURL)")
            imageUploadModel.uploadImageFile(email: Share.userEmail, menuNo: tempMenuNo, reviewContent: reviewContent, reviewStar: reviewStar, at: imageURL!, completionHandler: {_,_ in print("Upload Success")
                DispatchQueue.main.async { () -> Void in
                    self.navigationController?.popViewController(animated: true) // 현재화면 종료
                }
            })
        } else {
            print("imageUploadMode")
            imageUploadModel.nonImage(email: Share.userEmail, menuNo: tempMenuNo, reviewContent: reviewContent, reviewStar: reviewStar, completionHandler: {_,_ in print("NonImage Success")
                DispatchQueue.main.async { () -> Void in
                    self.navigationController?.popViewController(animated: true)// 현재화면 종료
                }
            })
        }
    } // img upload end
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tv_reviewContent.textColor == UIColor.lightGray {
            tv_reviewContent.text = nil
            tv_reviewContent.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if tv_reviewContent.text.isEmpty {
            tv_reviewContent.text = "내용을 입력해주세요."
            tv_reviewContent.textColor = UIColor.lightGray
        }
    }

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

} // END
