//
//  WriteViewController.swift
//  Moca
//
//  Created by Ria Song on 2021/02/28.
//

import UIKit

class WriteViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate, CheckBoardNoProtocol, UITextViewDelegate {
    
    // MARK: - 변수 Setting
    @IBOutlet var tv_boardContent: UITextView!
    @IBOutlet var txt_boardTitle: UITextField!
    @IBOutlet var iv_boardImgView: UIImageView!
    @IBOutlet var lbl_notice: UITextView!
    @IBOutlet var lbl_nonPhoto: UILabel!
    
    // UIImagePickerController 객체 생성
    let imagePickerController = UIImagePickerController()
    var imageURL: URL?
    var check = 0
    var boardNo = ""
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_nonPhoto.text = "사진을 첨부해주세요."
        imagePickerController.delegate = self
        
        // tv placeholder 설정
        tv_boardContent.delegate = self
        
        tv_boardContent.text = "내용을 작성해주세요."
        tv_boardContent.textColor = UIColor.lightGray
        tv_boardContent.selectedTextRange = tv_boardContent.textRange(from: tv_boardContent.beginningOfDocument, to: tv_boardContent.beginningOfDocument)
        
        // tv 테두리 설정
        tv_boardContent.layer.borderColor = UIColor.darkGray.cgColor
        tv_boardContent.layer.cornerRadius = 10
        tv_boardContent.layer.borderWidth = 0.5
        tv_boardContent.layer.masksToBounds = true
        
        // notice 설정
        let attributedStr = NSMutableAttributedString(string: lbl_notice.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 9
        attributedStr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedStr.length))
        lbl_notice.attributedText = attributedStr
        attributedStr.addAttribute(.foregroundColor, value: UIColor.red, range: (lbl_notice.text! as NSString).range(of: "삭제"))
        attributedStr.addAttribute(.foregroundColor, value: UIColor.blue, range: (lbl_notice.text! as NSString).range(of: "지양"))
        
        // 설정이 적용된 text를 label의 attributedText에 저장
        lbl_notice.attributedText = attributedStr
    } // end
    
    // MARK: - func Setting
    @IBAction func btnPhoto(_ sender: UIButton) {
        let photoAlert = UIAlertController(title: "사진 가져오기", message: "Photo Library에서 사진을 가져 옵니다.", preferredStyle: UIAlertController.Style.actionSheet) // Alert가 화면 밑에서 돌출
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        photoAlert.addAction(okAction)
        photoAlert.addAction(cancelAction)
        
        present(photoAlert, animated: true, completion: nil)
    }
    
    @IBAction func btnInsert(_ sender: UIBarButtonItem) {
        
        let resultAlert = UIAlertController(title: "완료", message: "입력되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
            self.imgUpload() // 이미지 func
        })
        resultAlert.addAction(onAction)
        present(resultAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            iv_boardImgView.image = image
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            lbl_nonPhoto.text = ""
            check = 1
        }
        // 켜놓은 앨범 화면 없애기
        dismiss(animated: true, completion: nil)
    }
    
    func imgUpload(){
        let boardTitle = txt_boardTitle.text!
        let boardContent = tv_boardContent.text!
        let boardInsertModel = BoardInsertModel()
        if check == 1 { // 이미지 업로드 시작
            print("imageUploadMode")
            boardInsertModel.uploadImageFile(boardTitle: boardTitle, boardContent: boardContent, at: imageURL!, completionHandler: {_,_ in print("Upload Success")
                DispatchQueue.main.async { () -> Void in
                    print("upload image File")
                
                    // instance
                    let checkBoardNo = CheckBoardNoModel()
                    checkBoardNo.delegate = self
                    checkBoardNo.downloadItemsBoardNo()
                }
            })
        } else { // 텍스트온리 업로드 시작
            print("non-imageUploadMode")
            boardInsertModel.nonImage(boardTitle: boardTitle, boardContent: boardContent, completionHandler: {_,_ in print("Non-image Upload Success!")
                DispatchQueue.main.async { () -> Void in
                    print("upload image File")
                    
                    // instance
                    let checkBoardNo = CheckBoardNoModel()
                    checkBoardNo.delegate = self
                    checkBoardNo.downloadItemsBoardNo()
                }
            })
        }
    } // imgupload func end
    
    // MARK: - protocol func Setting
    func itemDownloadedBoardNo(items: String) {
        boardNo = ""
        boardNo = items
        print("보드넘버는??? : \(boardNo)")
        let boardInsertModel = BoardInsertModel()
        boardInsertModel.InsertRegister(userInfo_userEmail: Share.userEmail, board_boardNo: boardNo, completionHandler: {_,_ in print("Register Upload Success")
            DispatchQueue.main.async { () -> Void in
                self.navigationController?.popViewController(animated: true) // 현재화면 종료
            }
        })
    }
    
    // placeholder 관련 func
    func textViewDidBeginEditing(_ textView: UITextView) {
        if tv_boardContent.textColor == UIColor.lightGray {
            tv_boardContent.text = nil
            tv_boardContent.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if tv_boardContent.text.isEmpty {
            tv_boardContent.text = "내용을 입력해주세요."
            tv_boardContent.textColor = UIColor.lightGray
        }
    }
    
    //    extension WriteViewController: UITextViewDelegate {
    //        // 텍스트뷰 placeHolder 설정
    //        // 편집이 시작될때
    //
    //        func textViewDidBeginEditing(_ textView: UITextView) { if tv_boardContent.textColor == UIColor.lightGray {// 1번
    //            tv_boardContent.text = nil
    //            tv_boardContent.textColor = UIColor.black
    //        }
    //        }
    //        // 편집이 종료될때
    //        func textViewDidEndEditing(_ textView: UITextView) {
    //            if tv_boardContent.text.isEmpty { // 2번
    //                tv_boardContent.text = "내용을 입력해주세요."
    //                tv_boardContent.textColor = UIColor.lightGray
    //            }
    //        }
    //    }
    
    
    
    
    
} // END
