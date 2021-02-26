//
//  LikeInsertModel.swift
//  Moca
//
//  Created by JiEunPark on 2021/02/26.
//

import Foundation

class LikeInsertModel: NSObject{
    
    var urlPath = "http://127.0.0.1:8080/swift_address/starInsert_ios.jsp"
    
    
    // insertItems의 () 매개변수들은 AddViewController에서 값을 넣어줘서 함께 실행할거고 → Bool로 실행 여부 확인할거야.
    func likeInsertItems(user_userEmail: String, address_addressNo: Int) -> Bool {
        var result: Bool = true
        let urlAdd = "?user_userEmail=\(user_userEmail)&address_addressNo=\(address_addressNo)"
        urlPath = urlPath + urlAdd
        
        // 한글 url encoding → 한글 글씨가 %로 바뀌어서 날아감.
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // 실제 url
        let url: URL = URL(string: urlPath)! // 텍스트 글자를 url모드로 바꿔줌
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        // task
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to insert data") // 앱스토어에 올릴때는 print 부분 다 지워야 함
                result = false
            } else {
                print("Data is inserted!")
                result = true
            }
        }
        task.resume() // resume()을 해줘야 task가 실행 된다.
        return result
    } // func END
}
