//
//  ReviewDBModel.swift
//  moca
//
//  Created by Ria Song on 2021/02/28.
//

import Foundation

class ReviewDBModel: NSObject{
    
    // Properties (Java의 field)
    var reviewNo: String?
    var menuNo: String?
    var userNickname: String?
    var reviewContent: String?
    var reviewStar: String?
    var reviewStarAvg: String?
    var reviewImg: String?
    var reviewInsertDate: String?
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
    
    // constructor
    init(reviewStarAvg: String){
        self.reviewStarAvg = reviewStarAvg
    }
    
    init(menuNo: String, reviewStarAvg: String){
        self.menuNo = menuNo
        self.reviewStarAvg = reviewStarAvg
    }
    
    init(reviewNo: String, menuNo: String, reviewContent: String, reviewStar: String, reviewImg: String, reviewInsertDate: String){
        self.reviewNo = reviewNo
        self.menuNo = menuNo
        self.reviewContent = reviewContent
        self.reviewStar = reviewStar
        self.reviewImg = reviewImg
        self.reviewInsertDate = reviewInsertDate
    }
    
    init(reviewNo: String, menuNo: String, userNickname: String, reviewContent: String, reviewStar: String, reviewImg: String, reviewInsertDate: String){
        self.reviewNo = reviewNo
        self.menuNo = menuNo
        self.userNickname = userNickname
        self.reviewContent = reviewContent
        self.reviewStar = reviewStar
        self.reviewImg = reviewImg
        self.reviewInsertDate = reviewInsertDate
    }
    init(reviewNo: String, menuNo: String, userNickname: String, reviewContent: String, reviewStar: String, reviewImg: String, reviewInsertDate: String, menuName:String, brandNo:String, brandName:String, menuPrice:String, menuImg:String, menuInformation:String, menuCalorie: String){
        self.reviewNo = reviewNo
        self.menuNo = menuNo
        self.userNickname = userNickname
        self.reviewContent = reviewContent
        self.reviewStar = reviewStar
        self.reviewImg = reviewImg
        self.reviewInsertDate = reviewInsertDate
        self.menuName = menuName
        self.brandNo = brandNo
        self.brandName = brandName
        self.menuPrice = menuPrice
        self.menuImg = menuImg
        self.menuInformation = menuInformation
        self.menuCalorie = menuCalorie
    }
  
    
    
}
