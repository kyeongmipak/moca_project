//
//  LikeDBModel.swift
//  Moca
//
//  Created by JiEunPark on 2021/02/26.
//

import Foundation

class LikeModel: NSObject{
    // Properties (Java의 field)
    var user_userEmail: String?
    var address_addressNo: Int?
    
    // Empty constructor
    override init() {
        
    }
    
    // constructor
    init(user_userEmail: String, address_addressNo: Int) {
        self.user_userEmail = user_userEmail
        self.address_addressNo = address_addressNo
    }
}
