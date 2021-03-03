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
class LoginViewController: UIViewController, GIDSignInDelegate, NaverThirdPartyLoginConnectionDelegate {
    
    // NaverLogin 연결 변수
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
     
        // Do any additional setup after loading the view.
        loginInstance?.delegate = self // naver login delegate 할당
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
        if (AuthApi.isKakaoTalkLoginAvailable()) {// 카카오톡 설치 여부 확인
            //설치가 되있으면 어플로 로그인을 실행
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    // 예외 처리 (로그인 취소 등)
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
    
    
    
    
    
    
    
    
}
