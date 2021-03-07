//
//  UserInfoProfileUpdateModel.swift
//  Moca
//
//  Created by  p2noo on 2021/03/05.
//

import Foundation

class UserInfoProfileUpdateModel: NSObject{
    
    var urlPath = "http://127.0.0.1:8080/moca/jsp/userinfo_profile_update.jsp"
   
    
    // return값을 true,false로 줘서 체크
    func updateItems(userPw: String, userNickname: String, userPhone: String, userImg: String, userEmail: String, completionHandler: @escaping(Data?, URLResponse?) -> Void) {
        
        let urlAdd = "?userPw=\(userPw)&userNickname=\(userNickname)&userPhone=\(userPhone)&userImg=\(userImg)&userEmail=\(userEmail)"
        urlPath = urlPath + urlAdd
        
        
        // 한글 url encoding,한글글씨가 %글씨로 변환된다
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){ data, res, _ in
            completionHandler(data, res)
        }
        task.resume()
        
    }
}
