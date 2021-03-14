//
//  LoginViewController.swift
//  Moca
//
//  Created by 박경미 on 2021/02/24.
//

import UIKit
import KakaoSDKAuth // 카카오 로그인
import KakaoSDKUser // 카카오 유저정보
import GoogleSignIn // 구글 로그인
import NaverThirdPartyLogin // 네이버 로그인
import Alamofire // http 통신
import SQLite3

class LoginViewController: UIViewController, GIDSignInDelegate, NaverThirdPartyLoginConnectionDelegate, UITextFieldDelegate, LogInModelProtocol {
    
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var switchLogin: UISwitch!
    
    var db: OpaquePointer?
    var email = [String]()
    var cheking = [Int]()
    var result = 0
    var overlapCheck = 0
    var iconClick = true
    
    // NaverLogin 연결 변수
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    // 지은 추가
    
    @IBOutlet weak var roundLogin: UIButton!
    @IBOutlet weak var roundSign: UIButton!
    @IBOutlet weak var roundPass: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // 지은 버튼 둥글게
        roundLogin.layer.cornerRadius = 15
        roundSign.layer.cornerRadius = 15
        roundPass.layer.cornerRadius = 15
        
        // Do any additional setup after loading the view.
        loginInstance?.delegate = self // naver login delegate 할당
        
        // SQLite 생성
        creatSQLite()
        
        // SQLite에 있는 데이터를 모두 불러옴
        readValues()
        
        // 불러온 데이터 중 자동로그인이 되어있는지 확인
        for i in 0..<cheking.count {
            if cheking[i] == 1 {
                // 자동로그인이 되어있으면 쉐어벨류에 아이디 저장
                Share.userEmail = email[i]
                // 로그인 화면에서 바로 메인 화면으로 넘기기
                self.performSegue(withIdentifier: "sgMain", sender: self)
            }
        }
        
        idTextField.delegate = self
        
//        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func btnNonUser(_ sender: UIButton) {
        self.performSegue(withIdentifier: "sgMain", sender: self)
        
    }
    
    @IBAction func btnKakaoLogin(_ sender: UIButton) {
        print("카카오톡 설치 여부 확인",AuthApi.isKakaoTalkLoginAvailable())
        if (AuthApi.isKakaoTalkLoginAvailable()){// 카카오톡 설치 여부 확인
            //설치가 되있으면 어플로 로그인을 실행
            print("설치가 되있으면 어플로 로그인을 실행")
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    // 예외 처리 (로그인 취소 등)
                    print("로그인 취소")
                    print(error)
                    
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    // do something
                    _ = oauthToken
                    // 어세스토큰
                    let accessToken = oauthToken?.accessToken
                    
                    //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
                    self.setUserInfo()
                    self.performSegue(withIdentifier: "sgMain", sender: self)
                }
            }
        }else{ // 카카오 로그인시 어플이 안깔려있으면 카카오 웹으로 로그인을 실행함
            print("카카오 웹으로 로그인")
            //AuthApi.shared.loginWithKakaoAccount(prompts:[.Login])으로 지정하면 로그인 상태여도 로그인을 물어봄
            AuthApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print("error",error)
                }
                else {
                    print("loginWithKakaoAccount() success.")
                    
                    //do something
                    _ = oauthToken
                    // 어세스토큰
                    let accessToken = oauthToken?.accessToken
                    
                    //카카오 로그인을 통해 사용자 토큰을 발급 받은 후 사용자 관리 API 호출
                    self.setUserInfo()
                    self.performSegue(withIdentifier: "sgMain", sender: self)
                }
            }
        }
    }
    
    
    func setUserInfo() {  // 카카오 유저정보 불러오는 Method
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                //do something
                _ = user
                print("유저정보", (user?.kakaoAccount?.profile?.nickname)!)
                print("이메일", (user?.kakaoAccount?.email)!)
                print("성별", (user?.kakaoAccount?.gender)!)
                //                print("생일", (user?.kakaoAccount?.birthday)!)
                Share.userEmail =  (user?.kakaoAccount?.email)!
                Share.userName =  (user?.kakaoAccount?.profile?.nickname)!
                //                Share.userBirth = (user?.kakaoAccount?.birthday)!
                //                Share.userEmail = (user?.kakaoAccount?.email)!
                //                print("Share",Share.userEmail)
                //                self.lblName.text = user?.kakaoAccount?.profile?.nickname
                
                
                if let url = user?.kakaoAccount?.profile?.profileImageUrl,
                   let data = try? Data(contentsOf: url) {
                    
                }
            }
        }
    }
    
    
    @IBAction func btnGoogleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    

    
    
    
    // 연동을 시도 했을때 불러오는 메소드
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        // 사용자 정보 가져오기
        if let userId = user.userID,                  // For client-side use only!
           let idToken = user.authentication.idToken, // Safe to send to the server
           let fullName = user.profile.name,
           let givenName = user.profile.givenName,
           let familyName = user.profile.familyName,
           let email = user.profile.email {
            
            print("Token : \(idToken)")
            print("User ID : \(userId)")
            print("User Email : \(email)")
            print("User Name : \((fullName))")
            Share.userName = fullName
            Share.userEmail = email
            
        } else {
            print("Error : User Data Not Found")
        }
        
        self.performSegue(withIdentifier: "sgMain", sender: self)
    }
    
    
    
    @IBAction func btnNaverLogin(_ sender: UIButton) {
        loginInstance?.requestThirdPartyLogin()
    }
    
    
    // 로그인에 성공한 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success login")
        getInfo()
    }
    
    // 접근 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        loginInstance?.accessToken
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        loginInstance?.requestDeleteToken()
    }
    
    // 모든 error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
    }
    
    
    // RESTful API, 유저정보 가져오기 (Alamofire로 가져옴,기본 네트워크 통신 사용 상관 X)
    func getInfo() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { // isValidAccessTokenExpireTimeNow 현재 토큰이 유요한지 , 유효시간 1시간
            print("로그인중")
            return
            
        }
        
        if !isValidAccessToken {
          
            return
        }
        
          guard let tokenType = loginInstance?.tokenType else { return }
          guard let accessToken = loginInstance?.accessToken else { return }
            
          let urlStr = "https://openapi.naver.com/v1/nid/me"
          let url = URL(string: urlStr)!

          let authorization = "\(tokenType) \(accessToken)"

          let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])

          req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let name = object["name"] as? String else { return }
            guard let email = object["email"] as? String else { return }
            guard let id = object["id"] as? String else {return}
            
            
            print(name)
            print(id)
            print(email)
            Share.userName = name
            Share.userEmail = email
            self.performSegue(withIdentifier: "sgMain", sender: self)
//            self.nameLabel.text = "\(name)"
//            self.emailLabel.text = "\(email)"
//            self.id.text = "\(id)"
            
          }
        }
    
    
    // 2021.3.4 대환
    
    @IBAction func passwordButton(_ sender: UIButton) {
        if(iconClick == true) {
                    passwordTextField.isSecureTextEntry=false
                } else {
                    passwordTextField.isSecureTextEntry = true
                }

        iconClick = !iconClick
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        getLoginData()
        Share.userEmail = idTextField.text!
        print("Login")
        print("Share.userEmail",Share.userEmail)
    }
    
    func creatSQLite() {
        // SQLite 생성하기
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("MOCASQLite.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS MOCASQLite (sid INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, cheking INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table : \(errmsg)")
        }
    }
    
    func readValues() {
        
        let queryString = "SELECT * FROM MOCASQLite"
        var stmt : OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select : \(errmsg)")
            return
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {        // 읽어올 데이터가 있는지
            let _ = sqlite3_column_int(stmt, 0)
            email.append(String(cString: sqlite3_column_text(stmt, 1)))
            cheking.append(Int(sqlite3_column_int(stmt, 2)))
        }
    }
    
    func getLoginData() {
        let logInModel = LogInModel()
        logInModel.delegate = self
        logInModel.downloadItems(userInformationEmail: idTextField.text!, userInformationPassword: passwordTextField.text!)
    }
    
    func itemDownloaded(items: Int) {
        result = items
        LoginCheck()
    }
    
    func LoginCheck() {
        switch result {                         // MySQL에서 입력한 값의 데이터가 있는지 확인
        case 1:
            if switchLogin.isOn == true {       // 자동로그인 스위치를 켰는지 확인
                // SQLite에 입력한 값이 있는지 확인
                for i in 0..<cheking.count {
                    // 만약 있다면 SQLite에 입력한 값의 아이디의 자동로그인 상태를 바꿔줌
                    if email[i] == idTextField.text! {
                        overlapCheck = 1
                        var stmt: OpaquePointer?
                        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)      // <--- 한글 들어가기 위해 꼭 필요
                        let queryString = "UPDATE MOCASQLite SET cheking = ? where email = ?"
                        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
                            let errmsg = String(cString: sqlite3_errmsg(db)!)
                            print("error preparing insert : \(errmsg)")
                            return
                        }
                        if sqlite3_bind_text(stmt, 1, "1", -1, SQLITE_TRANSIENT) != SQLITE_OK {
                            let errmsg = String(cString: sqlite3_errmsg(db)!)
                            print("error binding name : \(errmsg)")
                            return
                        }
                        if sqlite3_bind_text(stmt, 2, idTextField.text, -1, SQLITE_TRANSIENT) != SQLITE_OK {
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
                        let resultAlert = UIAlertController(title: "결과", message: "로그인이 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
                        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {ACTION in
                            Share.userEmail = self.email[i]
                            self.performSegue(withIdentifier: "sgMain", sender: self)
                        })
                        resultAlert.addAction(okAction)
                        present(resultAlert, animated: true, completion: nil)
                        print("Student saved successfully")
                    }
                }
                // SQLite에 입력한 값의 자료가 없다면 새로 입력함.
                switch overlapCheck {
                case 0:
                    var stmt: OpaquePointer?
                    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)      // <--- 한글 들어가기 위해 꼭 필요
                    
                    let queryString = "INSERT INTO MOCASQLite (email, cheking) VALUES (?,?)"
                    
                    if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("error preparing insert : \(errmsg)")
                        return
                    }
                    // 자동로그인 상태를 입력해줌
                    if sqlite3_bind_text(stmt, 1, idTextField.text, -1, SQLITE_TRANSIENT) != SQLITE_OK {
                        let errmsg = String(cString: sqlite3_errmsg(db)!)
                        print("error binding name : \(errmsg)")
                        return
                    }
                    if sqlite3_bind_text(stmt, 2, "1", -1, SQLITE_TRANSIENT) != SQLITE_OK {
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
                    let resultAlert = UIAlertController(title: "결과", message: "로그인이 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
                    let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {ACTION in
                        Share.userEmail = self.idTextField.text!
                        self.performSegue(withIdentifier: "sgMain", sender: self)
                    })
                    resultAlert.addAction(okAction)
                    present(resultAlert, animated: true, completion: nil)
                    print("Student saved successfully")
                    
                    
                    
                default:
                    break
                }
            } else{
                // 자동로그인 스위치를 키지 않은 경우는 그냥 쉐어벨류에 입력한 값을 저장해주고 메인화면으로 넘겨줌
                let resultAlert = UIAlertController(title: "결과", message: "로그인이 완료되었습니다.", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: {ACTION in
                    Share.userEmail = self.idTextField.text!
                    self.performSegue(withIdentifier: "sgMain", sender: self)
                })
                resultAlert.addAction(okAction)
                present(resultAlert, animated: true, completion: nil)
                print("Student saved successfully")
            }
        case 0:
            let userAlert = UIAlertController(title: "경고", message: "ID나 암호가 틀렸습니다.", preferredStyle: UIAlertController.Style.actionSheet)
            let onAction = UIAlertAction(title: "네, 알겠습니다.", style: UIAlertAction.Style.default, handler: nil)
            userAlert.addAction(onAction)
            present(userAlert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    // 아무곳이나 눌러 softkeyboard 지우기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
