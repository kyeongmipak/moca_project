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
import SQLite3

class MyPageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate,ImageSelectModelProtocol,UserInfoProfileIdCheckProtocol{

    
    
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
    var userInfoProfileId = UserInfoModel()
    var userEmail = Share.userEmail
    var checkUserEmail = ""
    // property 생성
    
    private var observer: NSObjectProtocol?
    
    // 2021.03.07 sqlite - 대환
    var db: OpaquePointer?
    
    // 지은 추가 -> 둘러보기 일때 버튼을 숨기기 위함
    
    @IBOutlet weak var hiddenPro: UIButton!
    @IBOutlet weak var hiddenLike: UIButton!
    @IBOutlet weak var hiddenLog: UIButton!
    @IBOutlet weak var hiddenSign: UIButton!
    @IBOutlet weak var hiddenReview: UIButton!
    
    @IBOutlet weak var hiddenLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Share.userEmail == "" {
            hiddenPro.isHidden = true
            hiddenLike.isHidden = true
            hiddenLog.isHidden = true
            hiddenSign.isHidden = true
            hiddenReview.isHidden = true
            hiddenLogin.isHidden = false
        }else{
            hiddenPro.isHidden = false
            hiddenLike.isHidden = false
            hiddenLog.isHidden = false
            hiddenSign.isHidden = false
            hiddenReview.isHidden = false
            hiddenLogin.isHidden = true
        }
        
   
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
        // profile border color
        myImg.layer.borderWidth = 1.0
        myImg.layer.borderColor = UIColor.lightGray.cgColor
        
        // imagePickerController
        imagePickerController.delegate = self
        
//        print("userEmail",Share.userEmail)
//        if userEmail == ""{
//
//        }else{
//        //DB image load
//        let imgSelectModel = ImageSelectModel()
//        imgSelectModel.delegate = self
//        imgSelectModel.downloadItems(userEmail: userEmail) // JsonModel.swift에 downloadItems 구동
//        }
        // 로그인한 id가 db에 있는지 확인
        let UserInfoProfileCheckModel = UserInfoProfileIdCheckModel()
        UserInfoProfileCheckModel.delegate = self
        UserInfoProfileCheckModel.downloadItems()
        print("id목록",userInfoProfileId)
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(MyPageViewController.imageReload(_:)), name: NSNotification.Name("Notification"), object: nil)
    }
    
    @objc func imageReload(_ notification:Notification) {
           print("실행")
           //실행시킬 코드
        let imgSelectModel = ImageSelectModel()
        imgSelectModel.delegate = self
        imgSelectModel.downloadItems(userEmail: Share.userEmail) // JsonModel.swift에 downloadItems 구동

    }
    
    
    
    @IBAction func btnMyProfile(_ sender: UIButton) {
        print("내 정보 수정 막기")
        if userEmail == "" {
            print("Alert창으로 알림 띄우기")
            
            let resultAlert = UIAlertController(title: "Moca 알림", message: "회원만 '내 정보 수정' 이 가능합니다.", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:nil)
            resultAlert.addAction(cancelAction)
            
        
            
            self.present(resultAlert, animated: true, completion: nil)
            
            
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
        
        // 2021.03.07 sqlite - 대환
        let resultAlert = UIAlertController(title: "로그 아웃", message: "로그아웃을 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "로그아웃", style: UIAlertAction.Style.default, handler: {ACTION in
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
            self.logOutForSqlite()
            // Share 초기화
            Share.userEmail = ""
            Share.userName = ""
            self.navigationController?.popViewController(animated: true)
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
        resultAlert.addAction(okAction)
        resultAlert.addAction(cancelAction)
        
        present(resultAlert, animated: true, completion: nil)
        
        print("Student saved successfully")
    }
    
    // 회원탈퇴 기능 구현
    @IBAction func btnSignout(_ sender: UIButton) {
   
        print("userEmail",userEmail,"userInfoProfileId.userEmail",userInfoProfileId.userEmail)
        
        if userEmail == checkUserEmail{
        let resultAlert = UIAlertController(title: "회원 탈퇴", message: "정말 회원탈퇴를 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "회원탈퇴", style: UIAlertAction.Style.default, handler: { [self]ACTION in
            
            let deleteModel = UserInfoProfileDeleteModel()
            let userEmail = Share.userEmail
         
            print("userEmail",userEmail)
            let result = deleteModel.deleteItem(userEmail: userEmail)
            if result == true{
                    let resultAlert = UIAlertController(title: "완료", message: "회원 탈퇴가 완료 되었습니다", preferredStyle: UIAlertController.Style.alert)
                    let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                        
                        self.deleteForSqlite()
                        self.navigationController?.popViewController(animated: true) //현재화면 지우기
                        
                    }
                    
                    )
                    resultAlert.addAction(onAction)
                    self.present(resultAlert, animated: true, completion: nil)
                
                
            self.navigationController?.popViewController(animated: true)
            }
        })
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.default, handler: nil)
        resultAlert.addAction(okAction)
        resultAlert.addAction(cancelAction)
        
        present(resultAlert, animated: true, completion: nil)
        }else{
            let resultAlert = UIAlertController(title: "Moca 알림", message: "소셜로그인은 내정보에 등록 후 탈퇴 가능합니다.", preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler:nil)
            resultAlert.addAction(cancelAction)

            self.present(resultAlert, animated: true, completion: nil)
        }
    
      
    }
    
    
    
    // 전화 문의 기능 구현
    @IBAction func btnCall(_ sender: UIButton) {
        if let phoneCallURL = URL(string: "tel://01011111111") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
   
    // 로그인 하러가기 기능 구현
    @IBAction func btnLogin(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
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
        print("receiveItem.userImg",receiveItem.userImg!)
        if receiveItem.userImg == "null" || receiveItem.userImg == ""{
            print("image nil")
        }else{
            print("image load")
//                  let url = URL(string: "http://127.0.0.1:8080/ios/\(receiveItem.image!)")
//          let url = URL(string: "http://127.0.0.1:8080/moca/image/\(receiveItem.userImg!)")
//        let data = try! Data(contentsOf: url!)
            
            var urlPath = "http://" + Share.macIP + "/moca/image/\(receiveItem.userImg!)"
            urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: urlPath)
            let data = try! Data(contentsOf: url!)
            myImg.image = UIImage(data: data)
      }
        print("receiveItem",receiveItem.userNickname!)
   
        myNickName.text = receiveItem.userName!
    }
    
    func userInfofindId(items: NSArray) {
        feedItem = items
        print(items.count)
        for i in 0...items.count - 1{
            
            userInfoProfileId = feedItem[i] as! UserInfoModel
            print("userInfoProfileId",userInfoProfileId.userEmail!)
            
            if userEmail != userInfoProfileId.userEmail{
                
            }else{
                //DB image load
                
                // id검색 후 없으면 ImageSelectModel 동작 X
                let imgSelectModel = ImageSelectModel()
                imgSelectModel.delegate = self
                imgSelectModel.downloadItems(userEmail: userEmail) // JsonModel.swift에 downloadItems 구동
                checkUserEmail = userEmail
                print("checkUserEmail",  checkUserEmail)
                print("userEmail",  userEmail)
            }
        
        }
    }
    
    func reloadImage() {
        print("MyPageViewController")
        let imgSelectModel = ImageSelectModel()
        imgSelectModel.delegate = self
        imgSelectModel.downloadItems(userEmail: Share.userEmail) // JsonModel.swift에 downloadItems 구동
    }
    
    // 2021.03.07 로그아웃 할 때 자동로그인 풀기 위한 펑션 추가
    func logOutForSqlite()  {
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)      // <--- 한글 들어가기 위해 꼭 필요
        
        let queryString = "UPDATE MOCASQLite SET cheking = ? where email = ?"
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert : \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, "0", -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding name : \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 2, Share.userEmail, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding dept : \(errmsg)")
            return
        }
        
        // sqlite 실행
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting : \(errmsg)")
            return
        }
        
    }
    
    func deleteForSqlite()  {
        var stmt: OpaquePointer?
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)      // <--- 한글 들어가기 위해 꼭 필요
        
        let queryString = "DELETE FROM MOCASQLite WHERE email = ?"
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert : \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, Share.userEmail, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error binding dept : \(errmsg)")
            return
        }
        
        // sqlite 실행
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting : \(errmsg)")
            return
        }
        
    }
    
}


