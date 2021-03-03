//
//  WriteViewController.swift
//  RyaDiary
//
//  Created by Ria Song on 2021/02/17.
//

import UIKit

class WriteViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate, CheckBoardNoProtocol {
    
    func itemDownloadedBoardNo(items: String) {
        boardNo = ""
        print("items \(items)")
        boardNo = items
        print("메뉴넘버는??? : \(boardNo)")
        
        let boardInsertModel = BoardInsertModel()
        
        boardInsertModel.InsertRegister(userInfo_userEmail: Share.userEmail, board_boardNo: boardNo, completionHandler: {_,_ in print("Register Upload Success")
            DispatchQueue.main.async { () -> Void in
                self.navigationController?.popViewController(animated: true) // 현재화면 종료
            }
        })
    }
    
    @IBOutlet var tv_boardContent: UITextView!
    @IBOutlet var txt_boardTitle: UITextField!
    @IBOutlet var lbl_userNickname: UILabel!
    @IBOutlet var iv_boardImgView: UIImageView!
    
    // UIImagePickerController 객체 생성
    let imagePickerController = UIImagePickerController()
    var imageURL: URL?
    var check = 0
    var boardNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
    } // end
    
    
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
            check = 1
        }
        // 켜놓은 앨범 화면 없애기
        dismiss(animated: true, completion: nil)
    }
    
    func imgUpload(){
        let boardTitle = txt_boardTitle.text!
        let boardContent = tv_boardContent.text!
        let boardInsertModel = BoardInsertModel()
        print("imageUpload")
        if check == 1 {
            
            boardInsertModel.uploadImageFile(boardTitle: boardTitle, boardContent: boardContent, at: imageURL!, completionHandler: {_,_ in print("Upload Success")
                DispatchQueue.main.async { () -> Void in
                    print("upload image File")
                    
                    // instance
                    let checkBoardNo = CheckBoardNoModel()
                    checkBoardNo.delegate = self
                    checkBoardNo.downloadItemsBoardNo()
                }
            })
            
} else {
    print("non-imageUploadMode")
    boardInsertModel.nonImage(boardTitle: boardTitle, boardContent: boardContent, completionHandler: {_,_ in print("Non-image Upload Success!")
        DispatchQueue.main.async { () -> Void in
            self.navigationController?.popViewController(animated: true) // 현재화면 종료
        }
    })
}
} // imgupload func end



} // END

