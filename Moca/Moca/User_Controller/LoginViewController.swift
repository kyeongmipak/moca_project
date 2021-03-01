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

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGoogleSignInButton()
        // Do any additional setup after loading the view.
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
        // 카카오톡 설치 여부 확인
        if (AuthApi.isKakaoTalkLoginAvailable()) {
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
                    self.performSegue(withIdentifier: "secondVC", sender: self)
                    
                }
            }
        }
    }
    
    
    func setUserInfo() {
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
    
    
    
    func setGoogleSignInButton(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        googleLoginButton.style = .standard // .wide .iconOnly
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
        
        //        self.performSegue(withIdentifier: "secondVC", sender: self)
    }
    
}
