//
//  SearchDBModel.swift
//  Moca
//
//  Created by 박경미 on 2021/02/24.
//

import Foundation

class SearchDBModel: NSObject {
    // Properties  (java에서는 field)
    var menuNo: String?
    var menuName: String?
    var brandNo: String?
    var brandName: String?
    var menuPrice: String?
    var menuInformation: String?
    var menuCalorie: String?
    var menuImg: String?
   
    // Empty constructor
    override init() {
        
    }
    
    // 빈생성자 사용했으므로 필요없다,
    init(menuNo: String, menuName:String, brandNo:String, brandName:String, menuPrice:String, menuInformation:String, menuCalorie: String, menuImg:String) {
        self.menuNo = menuNo
        self.menuName = menuName
        self.brandNo = brandNo
        self.brandName = brandName
        self.menuPrice = menuPrice
        self.menuInformation = menuInformation
        self.menuCalorie = menuCalorie
        self.menuImg = menuImg
    }
    
}
