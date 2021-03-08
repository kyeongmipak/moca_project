//
//  UserInfoProfileIdCheckModel.swift
//  Moca
//
//  Created by  p2noo on 2021/03/08.
//

import Foundation

// java의 interface개념
// Protocol
protocol UserInfoProfileIdCheckProtocol: class {
    func userInfofindId(items: NSArray)
}


class UserInfoProfileIdCheckModel: NSObject {
    var delegate: UserInfoProfileIdCheckProtocol!
//    let urlPath = "http://127.0.0.1:8080/ios/student_query_ios.jsp"
    var urlPath = "http://127.0.0.1:8080/moca/jsp/userinfo_profile_Idcheck.jsp"
   
    func downloadItems(){
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        print("urlPath", urlPath)
        let task = defaultSession.dataTask(with: url){(data, respond, error) in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloading")
                print("UserInfoProfieldCheck에서 다운로드 시작")
                self.parseJSON(data!) // URLSessionConfiguration에 있는 {(data, respond, error) 여기있는 data를 넣어줌
            }
        }
        task.resume() //downloadItems를 실행
        
    }
    
    
    
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray// Json file 불러오기, {}에 있는 데이터를 Array로 불러온다..
            
        }catch let error as NSError{
            print("parseJSON 에러 메세지 ")
            print(error)
        }
        
        var jsonElement = NSDictionary() // 괄호값 분해
        let locations = NSMutableArray() //
        
        
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary // Dictionary타입으로 변환

            
            if let userEmail = jsonElement["userEmail"] as? String{
                let query = UserInfoModel(userEmail: userEmail)
                //                query.scode = scode
                //                query.sname = sname
                //                query.sdept = sdept
                //                query.sphone = sphone
                locations.add(query)
               }
            
//            locations.add(query)
            
        }// for문 끝
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.userInfofindId(items: locations)
        })
            
        
    }
    
    
    
    
    
}
