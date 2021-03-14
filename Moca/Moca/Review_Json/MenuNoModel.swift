//
//  MenuNoModel.swift
//  main
//
//  Created by Ria Song on 2021/02/25.
//

import Foundation

// protocol은 DB의 table과 연결되어있기 때문에 필요한 것.
// insertModel에선 필요없다 (?)
protocol MenuModelProtocol: class{
    func itemDownloaded(items: NSArray) // <- 여기에 담은 아이템을 아래 delegate에서 사용하고, tableView에서 궁극적으로 사용.
}


class MenuModel: NSObject{
    var delegate: MenuModelProtocol!
    
    func downloadItems(menuNo : String){
        
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        var urlPath = "http://" + Share.macIP + "/moca/jsp/review_all_whereMenu.jsp" // 리뷰 전체, but 특정 MenuNo에 대해서 불러오기
        let urlAdd = "?menuNo=\(menuNo)"
        urlPath = urlPath + urlAdd
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlURL = URL(string: urlPath)
        
        let task = defaultSession.dataTask(with: urlURL!){(data, response, error) in
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
        //print(data)
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
        //let imglocations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            // jsonResult[i]번째를 NSDictionary 타입으로 변환
            jsonElement = jsonResult[i] as! NSDictionary
            //print("aaa", jsonElement)
            // DBModel instance 선언
            // let query = DBModel() // 배열이 비어있으므로 밑에 query.~~~ 다 연결해준것
            
            //  scode는 jsonElement의 code값인데, String으로 형변환 시켜.
            if let reviewNo = jsonElement["reviewNo"] as? String,
               let menuNo = jsonElement["menuNo"] as? String,
               let userNickname = jsonElement["userNickname"] as? String,
               let reviewContent = jsonElement["reviewContent"] as? String,
               let reviewStar = jsonElement["reviewStar"] as? String,
               let reviewImg = jsonElement["reviewImg"] as? String,
               let reviewInsertDate = jsonElement["reviewInsertDate"] as? String {
                // 아래처럼 미리 생성해놓은 constructor 사용해도 됨.
                //                print(">>>")
                // print(title, content, txtNo)
                let query = ReviewDBModel(reviewNo: reviewNo, menuNo: menuNo, userNickname: userNickname, reviewContent: reviewContent, reviewStar: reviewStar, reviewImg: reviewImg, reviewInsertDate: reviewInsertDate)
                locations.add(query) // locations 배열에 한뭉텅이씩 담기
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
} // END
