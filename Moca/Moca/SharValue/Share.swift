//
//  Share.swift
//  Moca
//
//  Created by 박경미 on 2021/02/24.
//

import Foundation

// 공통변수인 userId를 저장후 다른Class에서 참조
struct Share{
    static var userEmail: String = ""
    static var userName: String = ""
    static var userBirth: String = ""
//    static var userImage: String = ""
    
    static var macIP: String = "127.0.0.1:8080"
}
