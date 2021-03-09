//
//  BoardModel.swift
//  moca
//
//  Created by Ria Song on 2021/02/28.
//

import Foundation

class BoardModel: NSObject{
    
    // Properties (Java의 field)
    var boardNo: String?
    var userEmail: String?
    var userNickname: String?
    var boardTitle: String?
    var boardContent: String?
    var boardImg: String?
    var boardInsertDate: String?
    
    // Empty constructor
    override init() {
        
    }
    
    // constructor
    init(boardNo: String, userEmail: String, userNickname: String, boardTitle: String, boardContent: String, boardImg: String, boardInsertDate: String){
        self.boardNo = boardNo
        self.userEmail = userEmail
        self.userNickname = userNickname
        self.boardTitle = boardTitle
        self.boardContent = boardContent
        self.boardImg = boardImg
        self.boardInsertDate = boardInsertDate
    }
}
