//
//  MyUpdateViewController.swift
//  Moca
//
//  Created by JiEunPark on 2021/02/26.
//

import UIKit


//protocol UpdateDelegate: MyPageViewController {
//    func reloadImage()
//}

class MyUpdateViewController: UIViewController,UIImagePickerControllerDelegate & UINavigationControllerDelegate,ImageSelectModelProtocol, UserInfoProfileIdCheckProtocol {
  
 
   
    

    
    @IBOutlet weak var ivProfileImage: UIImageView!
    @IBOutlet weak var tfNickName: UITextField!
    @IBOutlet weak var tfPW: UITextField!
    @IBOutlet weak var tfTel: UITextField!
    
    
    // 프로필: url, imagePickerController 변수
    let imagePickerController = UIImagePickerController()
    var imageURL: URL?
    // ImageSelectModelProtocol itemdownload 변수
    var feedItem: NSArray = NSArray()
    var receiveItem = UserInfoModel()
    var userInfoProfileId = UserInfoModel()
    var userEmail = Share.userEmail
    var userNickname = ""
    var userTel = ""
    var userPw = ""
    var imgName = ""
    

    
    
    let firstController = MyPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 이미지 둥글게 만들기
        ivProfileImage.layer.cornerRadius = (ivProfileImage.frame.size.width) / 2
        ivProfileImage.layer.masksToBounds = true
        ivProfileImage.layer.borderWidth = 1.0
        ivProfileImage.layer.borderColor = UIColor.lightGray.cgColor
        // imagePickerController
        imagePickerController.delegate = self
        
        
        
        // 이미지뷰 클릭 제스처 설정
        ivProfileImage.isUserInteractionEnabled = true
        let event = UITapGestureRecognizer(target: self,
                                           action: #selector(clickMethod))
        ivProfileImage.addGestureRecognizer(event)
        
        
        
        // 로그인한 id가 db에 있는지 확인
        let UserInfoProfileCheckModel = UserInfoProfileIdCheckModel()
        UserInfoProfileCheckModel.delegate = self
        UserInfoProfileCheckModel.downloadItems()
        print("id목록",userInfoProfileId)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func itemDownload(items: NSArray) {
        print("----itemDownload 함수 작동-----")
        print(items)
        feedItem = items
        receiveItem = feedItem[0] as! UserInfoModel
        print("결과출력")
        print("receiveItem",receiveItem.userName!)
        print("receiveItem",receiveItem.userPhone!)
        print("receiveItem",receiveItem.userNickname!)

        if receiveItem.userImg == "null" || receiveItem.userImg == ""{
            print("image nil")
        }else{
            print("image load")
            //                  let url = URL(string: "http://127.0.0.1:8080/ios/\(receiveItem.image!)")
            let url = URL(string: "http://" + Share.macIP + "/moca/image/\(receiveItem.userImg!)")
            let data = try! Data(contentsOf: url!)
            print("data",data)
            ivProfileImage.image = UIImage(data: data)
        }
        
        print("userNickname",receiveItem.userNickname!)
        if receiveItem.userNickname!.isEmpty{
            tfNickName.text = ""
            print("들어와")
        }else{
        tfNickName.text = receiveItem.userNickname!
        }
        tfPW.text =  receiveItem.userPw!
        tfTel.text = receiveItem.userPhone!
    }
    
    func userInfofindId(items: NSArray) {
        feedItem = items
        print(items.count)
        for i in 0...items.count - 1{
            userInfoProfileId = feedItem[i] as! UserInfoModel
            print("userInfoProfileId",userInfoProfileId.userEmail!)
            print("userEmail",userEmail)
            if userEmail != userInfoProfileId.userEmail{
                print("userEmail 아이디와 검색한 아이디가 다르면")
            }else{
                //DB image load
                print("imgSelectModel")
                // id검색 후 없으면 ImageSelectModel 동작 X
                let imgSelectModel = ImageSelectModel()
                imgSelectModel.delegate = self
                imgSelectModel.downloadItems(userEmail: userEmail) // JsonModel.swift에 downloadItems 구동
            }
            
        }
        }
    
    
    
    
    
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
            print("image",image)
            ivProfileImage.image = image
            print("check : \(image)")
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            print("imageURL : \(imageURL!)")
            imgName = imageURL!.lastPathComponent
            print("imgName", imgName)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnProfileUpdate(_ sender: UIButton) {
        print("imageURL", imageURL)
        
        let userPw = tfPW.text
        let userNickname = tfNickName.text
        let userPhone = tfTel.text
        let userImg = imgName
        let userEmail = Share.userEmail
//
//
        if userEmail == userInfoProfileId.userEmail{
        let imageUploadModel = ImageUploadModel()
        if imageURL == nil { //예외 처리
        }else{
            imageUploadModel.uploadImageFile(userEmail: userEmail, at: imageURL!, completionHandler: {_,_ in
                print("Upload Success")
                print("delegate")
               
            })
            
        }
        let updateModel = UserInfoProfileUpdateModel()
        
        updateModel.updateItems(userPw: userPw!, userNickname: userNickname!, userPhone: userPhone!, userImg: userImg, userEmail: userEmail, completionHandler: {_,_ in
            DispatchQueue.main.async {
            let resultAlert = UIAlertController(title: "완료", message: "프로필 수정이 완료 되었습니다", preferredStyle: UIAlertController.Style.alert)
            let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                
                //옵저버 추가
                NotificationCenter.default.post(name: NSNotification.Name("Notification"), object: nil)
                
                self.navigationController?.popViewController(animated: true) //현재화면 지우기
              
                }
                
            )
            resultAlert.addAction(onAction)
                self.present(resultAlert, animated: true, completion: nil)
    }
        
    })
        }else{
            print("db에 없는 아이디로 내정보 수정할시에")
            let imageUploadModel = ImageUploadModel()
            if imageURL == nil { //예외 처리
            }else{
                imageUploadModel.uploadImageFile(userEmail: userEmail, at: imageURL!, completionHandler: {_,_ in
                    print("Upload Success")
                    print("delegate")
                   
                })
                
            }
            let insertModel = UserInfoProfileInsertModel()
            
            insertModel.insertItems(userPw: userPw!, userNickname: userNickname!, userPhone: userPhone!, userImg: userImg, userEmail: userEmail, completionHandler: {_,_ in
                DispatchQueue.main.async {
                let resultAlert = UIAlertController(title: "완료", message: "프로필 입력이 완료 되었습니다", preferredStyle: UIAlertController.Style.alert)
                let onAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {ACTION in
                    
                    //옵저버 추가
                    NotificationCenter.default.post(name: NSNotification.Name("Notification"), object: nil)
                    
                    self.navigationController?.popViewController(animated: true) //현재화면 지우기
                  
                    }
                    
                )
                resultAlert.addAction(onAction)
                    self.present(resultAlert, animated: true, completion: nil)
        }
            
        })
            
        }
    
    
    }
    
    // 아무곳이나 눌러 softkeyboard 지우기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
