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
class MyPageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var alertImg: UIImageView!
    
    // 상단에 띄울 나의 프로필 이미지와 닉네임 **********
    @IBOutlet weak var myNickName: UILabel!
    @IBOutlet weak var myImg: UIImageView!
    // *******************
    
    // 프로필: url, imagePickerController 변수
    let imagePickerController = UIImagePickerController()
    var imageURL: URL?
    // ImageSelectModelProtocol itemdownload 변수
    var userEmail = ""
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 이미지뷰를 터치했을때 이벤트 주기 +++++++++++++++++
        let tapAlert = UITapGestureRecognizer(target: self, action: #selector(touchToAlert))
        alertImg.addGestureRecognizer(tapAlert)
        alertImg.isUserInteractionEnabled = true
        // ++++++++++++++++++++++++++++++++++++++++
        
        
        // 이미지 둥글게 만들기
        myImg.layer.cornerRadius = (myImg.frame.size.width) / 2
        myImg.layer.masksToBounds = true
        
        // imagePickerController
        imagePickerController.delegate = self
        
        // 이미지뷰 클릭 제스처 설정
        myImg.isUserInteractionEnabled = true
        let event = UITapGestureRecognizer(target: self,
                                           action: #selector(clickMethod))
        myImg.addGestureRecognizer(event)
        
        print("userEmail",Share.userEmail)
    
    }
    
    // 알림 설정 기능 구현해서 넣기 -> 사진 바뀌는 것만 추가함
    // 개같은 박인우..........
    @objc func touchToAlert(sender: UITapGestureRecognizer) {
        
        if (sender.state == .ended) {
            // 켜져있을 때
            if alertImg.image == UIImage(named: "on.png") {
                print("끄기")
                alertImg.image = UIImage(named: "off.png")
            }else{
                // 꺼져있을 때
                print("켜기")
                alertImg.image = UIImage(named: "on.png")
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // profile image click 메소드
    @objc func clickMethod() {
        print("tapped")
        let photoAlert = UIAlertController(title: "사진 가져오기", message: "Photo Library에서 사진을 가져 옵니다.", preferredStyle: UIAlertController.Style.actionSheet) // Alert가 화면 밑에서 돌출
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { [self]ACTION in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: false, completion: nil) // animated: true로 해서 차이점을 확인해 보세요!
            print("imagePickerController \(String(describing: present))")
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        photoAlert.addAction(okAction)
        photoAlert.addAction(cancelAction)
        
        present(photoAlert, animated: true, completion: nil)
        
    }
    
    
    // Photo Library에서 사진 가져오기(함수 이름만 입력하면 준비된 함수임). Print해보면 위치를 알 수 있음.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { // 원본 이미지가 있을 경우
            
            myImg.image = image
            print("check : \(image)")
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            print("imageURL : \(imageURL!)")
            
        }
    
        print("nil value check : \(String(describing: imageURL))")
        
        let imageUploadModel = ImageUploadModel()
        if imageURL == nil { //예외 처리
            
        }else{
            imageUploadModel.uploadImageFile(userEmail: userEmail, at: imageURL!, completionHandler: {_,_ in print("Upload Success")})
        }
        
        
        // 켜놓은 앨범 화면 없애기
        dismiss(animated: true, completion: nil)
    }
}
