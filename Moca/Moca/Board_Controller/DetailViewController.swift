//
//  DetailViewController.swift
//  main
//
//  Created by Ria Song on 2021/02/27.
//

import UIKit

class DetailViewController: UIViewController {
    
    var receiveItem = BoardModel() // DBModel 객체 선언
    var txtNo = ""
    @IBOutlet var lbl_boardTitle: UILabel!
    @IBOutlet var lbl_userNickname: UILabel!
    @IBOutlet var tv_boardContent: UITextView!
    @IBOutlet var iv_boardImg: UIImageView!
    @IBOutlet var lbl_boardInsertDate: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = receiveItem.boardImg!
        
        //ReviewNo = receiveItem.reviewNo!
        
        lbl_boardTitle.text = receiveItem.boardTitle
        lbl_userNickname.text = receiveItem.userNickname
        tv_boardContent.text = receiveItem.boardContent
        lbl_boardInsertDate.text = receiveItem.boardInsertDate

        if urlString == "null" {
            // 이미지 없을때
            
        } else {
            // 이미지 있을때
            let url = URL(string: "http://127.0.0.1:8080/moca/image/\(receiveItem.boardImg!)")
            let data = try! Data(contentsOf: url!)
            iv_boardImg.image = UIImage(data: data)
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
    
    
    
    @IBAction func updateBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        // Delete 잘됨
//        let resultAlert = UIAlertController(title: "완료", message: "정말 삭제하시겠습니까? 삭제된 정보는 되돌릴 수 없습니다.", preferredStyle: UIAlertController.Style.alert)
//        let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
            
//            let txtNo = self.txtNo.text
            
//            let deleteModel = DeleteModel() // instance 선언
//            let result = deleteModel.deleteItems(txtNo: self.txtNo)
//
//            if result == true {
//                let resultAlert = UIAlertController(title: "완료", message: "삭제가 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
//                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
//                    self.navigationController?.popViewController(animated: true) // 현재화면 종료
//                })
//                resultAlert.addAction(onAction)
//                self.present(resultAlert, animated: true, completion: nil)
//            } else {
//                // insert 실패
//                let resultAlert = UIAlertController(title: "실패", message: "문제가 발생했습니다. 같은 에러가 지속적으로 발생하면 관리자에게 문의주세요.", preferredStyle: UIAlertController.Style.alert)
//                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
//                resultAlert.addAction(onAction)
//                self.present(resultAlert, animated: true, completion: nil) // 열심히 만든 알럿창 보여주는 함수
//            }
//        })
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler:nil)
//        resultAlert.addAction(onAction)
//        resultAlert.addAction(cancelAction)
//        present(resultAlert, animated: true, completion: nil) // 열심히 만든 알럿창 보여주는 함수
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
