//
//  SearchMenuInfo.swift
//  Moca
//
//  Created by Ria Song on 2021/03/08.
//

import Foundation

protocol SearchMenuInfoProtocol: class {
    func MenuInfoitemDownloaded(items: NSArray)
}

class SearchMenuInfo: NSObject {
    var delegate: SearchMenuInfoProtocol!
    
    func downloadItems(menuNo: String){
        
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        var urlPath = "http://" + Share.macIP + "/moca/jsp/search_menuInfo.jsp" // 리뷰 전체, but 특정 MenuNo에 대해서 불러오기
        let urlAdd = "?menuNo=\(menuNo)"
        urlPath = urlPath + urlAdd
    
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlURL = URL(string: urlPath)
        
        let task = defaultSession.dataTask(with: urlURL!){(data, response, error) in  // url을 실행하여 결과값을 data에 저장한다.
            if error != nil {
                print("Failed to download data")
                
            } else {
                print("Data is downloading")
                self.parseJSON(data!)
            }
        }
        
        task.resume() // 실행
    }
    
    func parseJSON(_ data: Data) {
        var jsonResult = NSArray()
        
        do {
            // json에서 { }로 묶인 데이터를 자체를 배열로 순서대로 저장한 모습
            // json 모습 탈피
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
            
        } catch let error as NSError {
            print(error)
        }
        
        // dictionary로 받는다 => 명칭 : data
        var jsonElement = NSDictionary()
        // dataaks 꺼내서 저장
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count {
            jsonElement = jsonResult[i] as! NSDictionary
            // 기본 생성자로 사용할 경우
//            let query = DBModel()
            
            // as? String => string으로 선언
            if let menuNo = jsonElement["menuNo"] as? String,
               let menuName = jsonElement["menuName"] as? String,
               let brandNo = jsonElement["brandNo"] as? String,
               let brandName = jsonElement["brandName"] as? String,
               let menuPrice = jsonElement["menuPrice"] as? String,
               let menuInformation = jsonElement["menuInformation"] as? String,
               let menuCalorie = jsonElement["menuCalorie"] as? String,
               let menuImg = jsonElement["menuImg"] as? String {
                let query = SearchDBModel(menuNo: menuNo, menuName: menuName, brandNo: brandNo, brandName: brandName, menuPrice: menuPrice, menuInformation: menuInformation, menuCalorie: menuCalorie, menuImg: menuImg)
                locations.add(query)
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.MenuInfoitemDownloaded(items: locations) // protocol의 함수에 넣고 구동시킨다.
        })
        
    }
}
