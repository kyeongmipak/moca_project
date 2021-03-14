//
//  MyReviewList.swift
//  main
//
//  Created by Ria Song on 2021/03/01.
//

import Foundation

// protocol은 DB의 table과 연결되어있기 때문에 필요한 것.
// insertModel에선 필요없다 (?)
protocol MyReviewListProtocol: class{
    func itemDownloaded(items: NSArray) // <- 여기에 담은 아이템을 아래 delegate에서 사용하고, tableView에서 궁극적으로 사용.
}


class MyReviewListModel: NSObject{
    var delegate: MyReviewListProtocol!

    func downloadItems(){
        
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        var urlPath = "http://" + Share.macIP + "/moca/jsp/my_review_list.jsp" // 리뷰 전체 불러오기
        let urlAdd = "?email=\(Share.userEmail)"
        urlPath = urlPath + urlAdd
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: urlPath)!
        
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
               let reviewInsertDate = jsonElement["reviewInsertDate"] as? String,
               let menuName = jsonElement["menuName"] as? String,
               let brandNo = jsonElement["brandNo"] as? String,
               let brandName = jsonElement["brandName"] as? String,
               let menuPrice = jsonElement["menuPrice"] as? String,
               let menuImg = jsonElement["menuImg"] as? String,
               let menuInformation = jsonElement["menuInformation"] as? String,
               let menuCalorie = jsonElement["menuCalorie"] as? String {
                // 아래처럼 미리 생성해놓은 constructor 사용해도 됨.
                print("json parsing 결과 \(menuName)\(brandName)")
                let query = ReviewDBModel(reviewNo: reviewNo, menuNo: menuNo, userNickname: userNickname, reviewContent: reviewContent, reviewStar: reviewStar, reviewImg: reviewImg, reviewInsertDate: reviewInsertDate, menuName: menuName, brandNo: brandNo, brandName: brandName, menuPrice: menuPrice, menuImg: menuImg, menuInformation: menuInformation, menuCalorie: menuCalorie)
                
                locations.add(query) // locations 배열에 한뭉텅이씩 담기
            }
        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)

        })
    }
    
    // 이미지 png/jpg를 바꿔줄 떄 사용 (?)
//    func getDocumentDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }
} // END
