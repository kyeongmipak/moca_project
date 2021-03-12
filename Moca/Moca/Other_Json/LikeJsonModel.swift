//
//  LikeJsonModel.swift
//  Moca
//
//  Created by JiEunPark on 2021/02/26.
//

import Foundation

// protocol은 DB의 table과 연결되어있기 때문에 필요한 것.
// insertModel에선 필요없다 (?)
protocol LikeJsonModelProtocol: class{
    func likeItemDownloaded(items: NSArray) // <- 여기에 담은 아이템을 아래 delegate에서 사용하고, tableView에서 궁극적으로 사용.
}

class LikeJsonModel: NSObject{
    var delegate: LikeJsonModelProtocol!
    var urlPath = "http://" + Share.macIP + "/moca/jsp/star_query_ios.jsp"
    
    func downloadItems(userEmail: String){
        let urlAdd = "?userEmail=\(Share.userEmail)"
        urlPath = urlPath + urlAdd
        
        // 한글 url encoding → 한글 글씨가 %로 바뀌어서 날아감.
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // 실제 url
        let url: URL = URL(string: urlPath)! // 텍스트 글자를 url모드로 바꿔줌
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error) in
            if error != nil{
                print("Failed to download data")
            } else {
                print("Data is downloading")
                // URLSession에 들어있는 data를 parsing
                self.parseJSON(data!)
            }
        }
        task.resume() // 위의 task를 실행해주는 함수.
    }
    
    func parseJSON(_ data: Data){
        var jsonResult = NSArray()
        
        do{
            // JSON 모델 탈피(?)
            // JSON 파일 불러오는 함수 → JSONSerialization
            // options ???
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        }catch let error as NSError{
            print(error)
        }
        
        // json은 key와 value값이 필요하므로 Dictionary 타입 사용
        var jsonElement = NSDictionary()
        
        let locations = NSMutableArray()
        
        print("LikeList for전")
        
        for i in 0..<jsonResult.count{
            // jsonResult[i]번째를 NSDictionary 타입으로 변환
            jsonElement = jsonResult[i] as! NSDictionary
            print("LikeList for후 \(jsonElement)")
            print("LikeList for후 \(jsonResult[i])")
            
            // DBModel instance 선언
            // let query = DBModel() // 배열이 비어있으므로 밑에 query.~~~ 다 연결해준것
            
            
            //  scode는 jsonElement의 code값인데, String으로 형변환 시켜.
            if let userInfo_userEmail = jsonElement["userInfo_userEmail"] as? String,
               let menu_menuNo = jsonElement["menu_menuNo"] as? Int,
               let menuName = jsonElement["menuName"] as? String,
               let menuPrice = jsonElement["menuPrice"] as? String,
               let menuImg = jsonElement["menuImg"] as? String,
               let menuCalorie = jsonElement["menuCalorie"] as? String,
               let menuInformation = jsonElement["menuInformation"] as? String,
               let menuCategory = jsonElement["menuCategory"] as? String,
               let brandName = jsonElement["brandName"] as? String{
                print("menuNo:\(menu_menuNo)")
                // 아래처럼 미리 생성해놓은 constructor 사용해도 됨.
                let query = LikeDBModel(userInfo_userEmail: userInfo_userEmail, menu_menuNo: menu_menuNo, menuName: menuName, menuPrice: menuPrice, menuImg: menuImg, menuCalorie: menuCalorie, menuInformation: menuInformation, menuCategory: menuCategory, brandName: brandName)
                locations.add(query) // locations 배열에 한뭉텅이씩 담기
                print("query = \(query)")
            }
            
            // locations.add(query) // locations 배열에 한뭉텅이씩 담기
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.likeItemDownloaded(items: locations)
            
        })
    }
    
} // END
