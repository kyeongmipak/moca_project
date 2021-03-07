//
//  MyPageViewController.swift
//  Moca
//
//  Created by 박경미 on 2021/02/24.
//

import UIKit
import GoogleSignIn // Google Login import
import KakaoSDKUser // Kakao Login import
import NaverThirdPartyLogin // Naver Login import
import UserNotifications // pushNotifications import

class MyPageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,ImageSelectModelProtocol, UpdateDelegate {
    
    @IBOutlet weak var alertImg: UIImageView!
    
    // 상단에 띄울 나의 프로필 이미지와 닉네임 **********
    @IBOutlet weak var myNickName: UILabel!
    @IBOutlet weak var myImg: UIImageView!
    // *******************
    
    // 프로필: url, imagePickerController 변수
    let imagePickerController = UIImagePickerController()
    var imageURL: URL?
    
    // ImageSelectModelProtocol itemdownload 변수
    var feedItem: NSArray = NSArray()
    var receiveItem = UserInfoModel()
    var userEmail = ""
    // property 생성
    
    private var observer: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        // 이미지뷰를 터치했을때 이벤트 주기 +++++++++++++++++
        let tapAlert = UITapGestureRecognizer(target: self, action: #selector(touchToAlert))
        alertImg.addGestureRecognizer(tapAlert)
        alertImg.isUserInteractionEnabled = true
        // ++++++++++++++++++++++++++++++++++++++++
        
        // id
        myNickName.text = Share.userName
        userEmail = Share.userEmail
        // 이미지 둥글게 만들기
        myImg.layer.cornerRadius = (myImg.frame.size.width) / 2
        myImg.layer.masksToBounds = true
        
        // imagePickerController
        imagePickerController.delegate = self
        
        print("userEmail",Share.userEmail)
     
        
        if userEmail == ""{
    
        }else{
        //DB image load
        let imgSelectModel = ImageSelectModel()
        imgSelectModel.delegate = self
        imgSelectModel.downloadItems(userEmail: userEmail) // JsonModel.swift에 downloadItems 구동
        }
        
        // 알림센터에 옵저버를 적용
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                          object: nil,
                                                          queue: .main) {
            [unowned self] notification in
            // background에서 foreground로 돌아오는 경우 실행 될 코드
            UNUserNotificationCenter.current().requestAuthorization(options: [ .sound, .badge]) { [self](result, Error)in // 사용자 권한 요청
                print("result1",result)// 알림 권한 요청 결과값
                
                DispatchQueue.main.async { // 뒤늦게 리로드 되는 문제를 해결, 메인스레드에서 사용가능하게 해주는듯?
                if result == true{
                    alertImg.image = UIImage(named: "on.png")
                }else{
                    alertImg.image = UIImage(named: "off.png")
                }
                }
            }
        }
        
       
        
    }
    
    @IBAction func btnMyProfile(_ sender: UIButton) {
        print("내 정보 수정 막기")
        if userEmail == "" {
            print("Alert창으로 알림 띄우기")
            
            let resultAlert = UIAlertController(title: "Moca 알림", message: "회원만 '내 정보 수정' 이 가능합니다.", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:nil)
            resultAlert.addAction(cancelAction)
            
           
        
            
//            self.present(resultAlert, animatedle true, completion: nil)
            
            
        }else{
            print("그냥 들어가게")
        }
    }
    
    
    // 알림 설정 기능 구현해서 넣기 -> 사진 바뀌는 것만 추가함
    @objc func touchToAlert(sender: UITapGestureRecognizer) {
 
   
        if (sender.state == .ended) {
            UNUserNotificationCenter.current().requestAuthorization(options: [ .sound, .badge]) { [self](result, Error)in // 사용자 권한 요청
                print("result1",result)// 알림 권한 요청 결과값
            
            // 켜져있을 때
            if result == true {
                print("끄기")
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
                
            }else{
                // 꺼져있을 때
                print("켜기")
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
               
            }
            }
        }
    }
    
    
    // 로그아웃 기능 구현
    @IBAction func btnLogout(_ sender: UIButton) {
        let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                
            }
        }
        
        GIDSignIn.sharedInstance()?.signOut()
        
        loginInstance?.requestDeleteToken()
        // Share 초기화
        Share.userEmail = ""
        Share.userName = ""
        
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    // 회원탈퇴 기능 구현
    @IBAction func btnSignout(_ sender: UIButton) {
        
        
    }
    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//
//
//    }
//
    @IBAction func btnMyReviewList(_ sender: UIButton) {
        if Share.userEmail != "" {
            //            performSegue(withIdentifier: "sgWriteBoard", sender: sender)
        } else {
            let resultAlert = UIAlertController(title: "Moca 알림", message: "회원만 리뷰목록 확인이 가능합니다.", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:nil)
            resultAlert.addAction(cancelAction)
            self.present(resultAlert, animated: true, completion: nil)
        }
        
    }

    func itemDownload(items: NSArray) {
        print("----itemDownload 함수 작동-----")
        print(items)
        feedItem = items
        receiveItem = feedItem[0] as! UserInfoModel
        print("결과출력")
        print("receiveItem.userImg",receiveItem.userImg)
        if receiveItem.userImg == nil, receiveItem.userImg == ""{
            print("image nil")
        }else{
            print("image load")
//                  let url = URL(string: "http://127.0.0.1:8080/ios/\(receiveItem.image!)")
          let url = URL(string: "http://127.0.0.1:8080/moca/image/\(receiveItem.userImg!)")
        let data = try! Data(contentsOf: url!)
        myImg.image = UIImage(data: data)
      }
        
    }
    
    func reloadImage() {
        print("MyPageViewController")
        let imgSelectModel = ImageSelectModel()
        imgSelectModel.delegate = self
        imgSelectModel.downloadItems(userEmail: Share.userEmail) // JsonModel.swift에 downloadItems 구동
    }
    
}


