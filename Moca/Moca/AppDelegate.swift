//
//  AppDelegate.swift
//  Moca
//
//  Created by 박경미 on 2021/02/24.
//

import UIKit

// kakao
import KakaoSDKCommon

// google
import GoogleSignIn
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // launch screen 
        sleep(3)
        
        // 카카오 로그인 앱키
        KakaoSDKCommon.initSDK(appKey: "ed5d4ef21df85e7f6eddb48b5cc2579d")

        
        // 파이어베이스와 구글 로그인 연동 추가
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = "408732211320-g2pg9o7h2qmhu3dhulpdba1k3sfm5q6m.apps.googleusercontent.com"
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

