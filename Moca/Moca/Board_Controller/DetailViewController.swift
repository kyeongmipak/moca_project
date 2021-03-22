//
//  DetailViewController.swift
//  main
//
//  Created by Ria Song on 2021/02/27.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var receiveItem = BoardModel() // DBModel 객체 선언

    @IBOutlet var txt_boardTitle: UITextField!
    @IBOutlet var lbl_userNickname: UILabel!
    @IBOutlet var tv_boardContent: UITextView!
    @IBOutlet var iv_boardImg: UIImageView!
    @IBOutlet var lbl_boardInsertDate: UILabel!
    @IBOutlet var rightBarButton: UIBarButtonItem!
    @IBOutlet var btnPhotoview: UIButton!
    var imgCheck = 0
    var check = 0
    let imagePickerController = UIImagePickerController()
    var imageURL: URL?
    var existingimageURL: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Setting
        if Share.userEmail == receiveItem.userEmail {
            navigationItem.rightBarButtonItem = rightBarButton // show
            tv_boardContent.isEditable = true
            txt_boardTitle.isEnabled = true
            btnPhotoview.isHidden = false
        } else {
            navigationItem.rightBarButtonItem = nil // hide
            tv_boardContent.isEditable = false // read only
            txt_boardTitle.isEnabled = false
            btnPhotoview.isHidden = true
        }
        
        // imagePickerController delegate Setting
        imagePickerController.delegate = self
        
        let urlString = receiveItem.boardImg!
        
        txt_boardTitle.text = receiveItem.boardTitle
        lbl_userNickname.text = receiveItem.userNickname
        tv_boardContent.text = receiveItem.boardContent
        lbl_boardInsertDate.text = receiveItem.boardInsertDate

        if urlString == "null" {
            // 이미지 없을때
            
        } else {
            // 이미지 있을때
            var urlPath = "http://" + Share.macIP + "/moca/image/\(receiveItem.boardImg!)"
            urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: urlPath)
            let data = try! Data(contentsOf: url!)
            iv_boardImg.image = UIImage(data: data)
//            imgCheck = 1
            check = 1
        }
        
        
    } // viewDidLoad END -----
    
    @IBAction func btnShare(_ sender: UIButton) {
        var objectsToShare = [String]()
                if let text = tv_boardContent.text {
                    objectsToShare.append(text)
                    print("[INFO] textField's Text : ", text)
                }
                
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                
                // 공유하기 기능 중 제외할 기능이 있을 때 사용
        //        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
                self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func btnReport(_ sender: UIButton) {
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
            let resultAlert = UIAlertController(title: "게시글 신고", message: "해당 게시글을 부적절한 게시글로 신고하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "신고", style: UIAlertAction.Style.default, handler: {ACTION in
                
                    let resultAlert = UIAlertController(title: "", message: "신고되었습니다.\n관리자 확인 후 조치하겠습니다.", preferredStyle: UIAlertController.Style.alert)
                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                        self.navigationController?.popViewController(animated: true) // 현재화면 종료
                    })
                    resultAlert.addAction(onAction)
                    self.present(resultAlert, animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive, handler:nil)
            resultAlert.addAction(onAction)
            resultAlert.addAction(cancelAction)
            self.present(resultAlert, animated: true, completion: nil) // 열심히 만든 알럿창 보여주는 함수
    }
    
    @IBAction func btnOpenPhoto(_ sender: UIButton) {
        
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
            iv_boardImg.image = image
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
//            lbl_NonPhoto.text = ""
            check = 2
        }
        // 켜놓은 앨범 화면 없애기
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreMenu(_ sender: UIBarButtonItem) {
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "수정", style: UIAlertAction.Style.default, handler: { ACTION in
            
            let resultAlert = UIAlertController(title: "완료", message: "게시물이 수정되었습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                self.imgUpload()
            })
            resultAlert.addAction(onAction)
            self.present(resultAlert, animated: true, completion: nil)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: { ACTION in
            let resultAlert = UIAlertController(title: "MOCA 알림", message: "정말 삭제하시겠습니까? \n삭제된 정보는 되돌릴 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "삭제", style: UIAlertAction.Style.destructive, handler: {ACTION in
                
                var tempBoardNo2 = self.receiveItem.boardNo
                print("board No >>>>> \(tempBoardNo2)")
                
                let deleteModel = BoardDeleteModel() // instance 선언
                let result = deleteModel.deleteItems(boardNo: tempBoardNo2!)
             
                
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

    } // func end
            
    func imgUpload(){
        let boardNo = receiveItem.boardNo!
        let boardTitle = txt_boardTitle.text!
        let boardContent = tv_boardContent.text!
        let boardImg = receiveItem.boardImg!
        print("boardImg는???????? \(boardImg)")
        let boardUpdateModel = BoardUpdateModel()
        
        switch check {
        case 0:
            print("non-image Update 시작 ----\(boardContent)")
                        boardUpdateModel.nonImage(boardNo: boardNo, boardTitle: boardTitle, boardContent: boardContent, completionHandler: {_,_ in print("Non_image Update Success")
                            DispatchQueue.main.async { () -> Void in
                                self.navigationController?.popViewController(animated: true)
                            }
                            print("non-image Update 완료 ----")
                        })
        case 1:
            print("existing-image Update 시작 ----\(boardTitle)\(boardContent)\(boardImg)")
                     boardUpdateModel.existingImage(boardNo: boardNo, boardTitle: boardTitle, boardContent: boardContent, boardImg: boardImg, completionHandler: {_,_ in print("existing image Update Success")
                         DispatchQueue.main.async { () -> Void in
                             self.navigationController?.popViewController(animated: true)
                         }
                         print("existing-image Update 완료 ----")
                     })
        case 2:
            print("image Update 시작 ----")
                        boardUpdateModel.uploadImageFile(boardNo: boardNo, boardTitle: boardTitle, boardContent: boardContent, at: imageURL!, completionHandler: {_,_ in print("Update Success")
                            DispatchQueue.main.async { () -> Void in
                                self.navigationController?.popViewController(animated: true)
                            }
                            print("image Update 완료 ----")
                        })
        default:
            break
        }
        
        
//        if check == 1 {
//            print("image Update 시작 ----")
//            boardUpdateModel.uploadImageFile(boardNo: boardNo, boardTitle: boardTitle, boardContent: boardContent, at: imageURL!, completionHandler: {_,_ in print("Update Success")
//                DispatchQueue.main.async { () -> Void in
//                    self.navigationController?.popViewController(animated: true)
//                }
//                print("image Update 완료 ----")
//            })
//        }
//         if imgCheck == 1 {
//            print("existing-image Update 시작 ----\(boardContent)")
//            boardUpdateModel.existingImage(boardNo: boardNo, boardTitle: boardTitle, boardContent: boardContent, boardImg: boardImg, completionHandler: {_,_ in print("existing image Update Success")
//                DispatchQueue.main.async { () -> Void in
//                    self.navigationController?.popViewController(animated: true)
//                }
//                print("existing-image Update 완료 ----")
//            })
//        } else {
//            print("non-image Update 시작 ----\(boardContent)")
//            boardUpdateModel.nonImage(boardNo: boardNo, boardTitle: boardTitle, boardContent: boardContent, completionHandler: {_,_ in print("Non_image Update Success")
//                DispatchQueue.main.async { () -> Void in
//                    self.navigationController?.popViewController(animated: true)
//                }
//                print("non-image Update 완료 ----")
//            })
//        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
