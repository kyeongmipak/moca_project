//
//  MyReviewDetailViewController.swift
//  main
//
//  Created by Ria Song on 2021/03/02.
//

import UIKit
import Cosmos
import TinyConstraints

class MyReviewDetailViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    // MARK: - 변수 setting
    var receiveItem = ReviewDBModel()
    var check = 0
    var imgcheck = 0
    let imagePickerController = UIImagePickerController()
    var imageURL: URL?
    var rate :Double = Double()
    var tempStar = ""
    var reviewNo : String = ""
    
    @IBOutlet var ratingStar: CosmosView!
    @IBOutlet var tv_reviewContent: UITextView!
    @IBOutlet var iv_imgView: UIImageView!
    @IBOutlet var lbl_NonPhoto: UILabel!
    @IBOutlet var lbl_notice: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 불러온 거 setting
        // NSMutableAttributedString Type으로 바꾼 text를 저장
        let attributedStr = NSMutableAttributedString(string: lbl_notice.text!)
        
        // 크기
        //        let font = UIFont(name:"Apple Color Emoji" , size: 16)
        //        lbl_notice.attributedText = attributedStr
        //        attributedStr.addAttribute(.font, value: font, range: NSMakeRange( attributedStr.length, Int))
        
        // spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        
        attributedStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedStr.length))
        lbl_notice.attributedText = attributedStr;
        
        // text의 range 중에서 "~"라는 글자는 UIColor를 red로 변경
        attributedStr.addAttribute(.foregroundColor, value: UIColor.blue, range: (lbl_notice.text! as NSString).range(of: "수정"))
        attributedStr.addAttribute(.foregroundColor, value: UIColor.red, range: (lbl_notice.text! as NSString).range(of: "삭제"))
        
        // 설정이 적용된 text를 label의 attributedText에 저장
        lbl_notice.attributedText = attributedStr
        
        tv_reviewContent.text = receiveItem.reviewContent
        
        tv_reviewContent.layer.borderColor = UIColor.black.cgColor
        tv_reviewContent.layer.cornerRadius = 10
        tv_reviewContent.layer.borderWidth = 0.5
        tv_reviewContent.layer.masksToBounds = true
        
        if let rating = Double("\(receiveItem.reviewStar!)") {
            print("☆☆☆☆☆",receiveItem.reviewStar!)
            print(rating)
            ratingStar.rating = rating
        }
        if receiveItem.reviewImg == "null" {
            // 이미지 없을때
            lbl_NonPhoto.text = "등록한 사진이 없습니다."
        } else {
            lbl_NonPhoto.text = ""
            let url = URL(string: "http://" + Share.macIP + "/moca/image/\(receiveItem.reviewImg!)")
            print("url : \(url)")
            let data = try! Data(contentsOf: url!)
            iv_imgView.image = UIImage(data: data)
            imgcheck = 1
        }
        print("receiveItem.reviewNo >>>> \(receiveItem.reviewNo!)")
        
        // imagePickerController delegate Setting
        imagePickerController.delegate = self
        
        // MARK: Cosmos setting
        ratingStar.settings.totalStars = 5 // max = 5
        ratingStar.settings.fillMode = .half
        
        ratingStar.didTouchCosmos = {
            rating in
            self.rate = rating
            print(rating)
            
            self.tempStar = String(rating)
            print("self.tempStar\(self.tempStar) = rating\(rating)" )
        } // cosmos setting
    }
    // 아무곳이나 눌러 softkeyboard 지우기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func moreMenu(_ sender: UIBarButtonItem) {
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "수정", style: UIAlertAction.Style.default, handler: { ACTION in
            
            let resultAlert = UIAlertController(title: "완료", message: "리뷰가 수정되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                self.imgUpload()
            })
            resultAlert.addAction(onAction)
            self.present(resultAlert, animated: true, completion: nil)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: { ACTION in
            // Delete 잘됨
            let resultAlert = UIAlertController(title: "MOCA 알림", message: "정말 삭제하시겠습니까? \n삭제된 정보는 되돌릴 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "삭제", style: UIAlertAction.Style.default, handler: {ACTION in
                
                //            let txtNo = self.txtNo.text
                
                let deleteModel = ReviewDeleteModel() // instance 선언
                let result = deleteModel.deleteItems(reviewNo: self.receiveItem.reviewNo!)
                
                if result == true {
                    let resultAlert = UIAlertController(title: "완료", message: "삭제가 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                        self.navigationController?.popViewController(animated: true) // 현재화면 종료
                    })
                    resultAlert.addAction(onAction)
                    self.present(resultAlert, animated: true, completion: nil)
                } else {
                    // insert 실패
                    let resultAlert = UIAlertController(title: "실패", message: "문제가 발생했습니다. \n같은 에러가 지속적으로 발생하면 관리자에게 문의주세요.", preferredStyle: UIAlertController.Style.alert)
                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                    resultAlert.addAction(onAction)
                    self.present(resultAlert, animated: true, completion: nil) // 열심히 만든 알럿창 보여주는 함수
                }
            })
            let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler:nil)
            resultAlert.addAction(onAction)
            resultAlert.addAction(cancelAction)
            self.present(resultAlert, animated: true, completion: nil) // 열심히 만든 알럿창 보여주는 함수
        }))
        actionsheet.addAction(UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil))
        present(actionsheet, animated: true, completion: nil)
    }
    
    
    @IBAction func btnPhotoLibrary(_ sender: UIButton) {
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            iv_imgView.image = image
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            print("imageURL ________ \(imageURL)")
            lbl_NonPhoto.text = ""
            check = 1
        }
        
        // 켜놓은 앨범 화면 없애기
        dismiss(animated: true, completion: nil)
    }
    
    func imgUpload(){
        let reviewNo = receiveItem.reviewNo!
        let reviewContent = tv_reviewContent.text!
        let reviewStar = tempStar
        let reviewUpdateModel = ReviewUpdateModel()
        
        if check == 1 || imgcheck == 1 {
            print("image Update 시작 ----")
            reviewUpdateModel.uploadImageFile(reviewNo: reviewNo, reviewContent: reviewContent, reviewStar: reviewStar, at: imageURL!, completionHandler: {_,_ in print("Update Success")
                print(">>>>잘보내는거마쟌?\(reviewNo)>>>\(reviewContent)>>>\(reviewStar)")
                DispatchQueue.main.async { () -> Void in
                    self.navigationController?.popViewController(animated: true)
                }
                print("image Update 완료 ----")
            })
        } else {
            print("non-image Update 시작 ----\(reviewContent)")
            reviewUpdateModel.nonImage(reviewNo: reviewNo, reviewContent: reviewContent, reviewStar: reviewStar, completionHandler: {_,_ in print("Non_image Update Success")
                DispatchQueue.main.async { () -> Void in
                    self.navigationController?.popViewController(animated: true)
                }
            })
            print("non-image Update 완료 ----")
        }
    } // img upload end
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
