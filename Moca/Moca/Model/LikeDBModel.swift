//
//  LikeDBModel.swift
//  Moca
//
//  Created by JiEunPark on 2021/03/07.
//

import Foundation
class LikeDBModel: NSObject{
    // Properties (Java의 field)
    var userInfo_userEmail: String?
    var menu_menuNo: Int?
    var menuName: String?
    var menuPrice: String?
    var menuImg: String?
    var menuCalorie: String?
    var menuInformation: String?
    var menuCategory: String?
    var brandName: String?
    
    // Empty constructor
    override init() {
        
    }
    
    // constructor
    init(userInfo_userEmail: String, menu_menuNo: Int) {
        self.userInfo_userEmail = userInfo_userEmail
        self.menu_menuNo = menu_menuNo
    }
    
    init(userInfo_userEmail: String, menu_menuNo: Int, menuName: String, menuPrice: String, menuImg: String, menuCalorie: String, menuInformation: String, menuCategory: String, brandName: String) {
        self.userInfo_userEmail = userInfo_userEmail
        self.menu_menuNo = menu_menuNo
        self.menuName = menuName
        self.menuPrice = menuPrice
        self.menuImg = menuImg
        self.menuCalorie = menuCalorie
        self.menuInformation = menuInformation
        self.menuCategory = menuCategory
        self.brandName = brandName
    }
   
}
