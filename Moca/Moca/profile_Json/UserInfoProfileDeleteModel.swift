//
//  UserInfoProfileDeleteModel.swift
//  Moca
//
//  Created by  p2noo on 2021/03/08.
//

import Foundation
class UserInfoProfileDeleteModel: NSObject{
var urlPath = "http://127.0.0.1:8080/moca/jsp/userinfo_profile_delete.jsp"

    // return값을 true,false로 줘서 체크
    func deleteItem(userEmail: String) -> Bool {
        var result: Bool = true
        print("userEmail deleteItem",userEmail)
        let urlAdd = "?userEmail=\(userEmail)"
        urlPath = urlPath + urlAdd
        print("urlPath",urlPath)
        
        // 한글 url encoding,한글글씨가 %글씨로 변환된다
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to insert data")
                result = false //에러체크
            }else{
                print("Data is inserted!")
                result = true
            }
            
            
        }
        task.resume() // task 동작
        return result
    }
    
    
}
