//
//  UserInfoModel.swift
//  Moca
//
//  Created by  p2noo on 2021/03/03.
//

import Foundation

class UserInfoModel: NSObject{
    
    // java에서는 field ios에서는 Properties
    // Properties
    var userEmail: String?
    var userPw: String?
    var userName: String?
    var userNickname: String?
    var userPhone: String?
    var userBirth: String?
    var userImg: String?
    var userInsertDate: String?
    var userDeleteDate: String?
    
    // Empty constructor
    override init() {

    }
    
    
//    init(scode: String, sname: String, sdept: String, sphone: String){
//        self.scode = scode
//        self.sname = sname
//        self.sdept = sdept
//        self.sphone = sphone
//    }
    
    init(userEmail: String, userPw: String, userName: String,userNickname: String, userPhone: String, userBirth: String, userImg: String,userInsertDate: String){
         self.userEmail = userEmail
         self.userPw = userPw
         self.userName = userName
         self.userNickname = userNickname
         self.userPhone = userPhone
         self.userBirth = userBirth
        self.userImg = userImg
        self.userInsertDate = userInsertDate

    }
    
    init(userEmail: String? = nil) {
        self.userEmail = userEmail
    }
    
}
