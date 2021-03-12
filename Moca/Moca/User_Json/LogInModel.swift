//
//  LogInModel.swift
//  Moca
//
//  Created by 김대환 on 2021/03/04.
//

import Foundation

protocol LogInModelProtocol: class {
    func itemDownloaded(items: Int)
}

class LogInModel: NSObject {
    var delegate : LogInModelProtocol!
    var urlPath = "http:/" + Share.macIP + "/moca/jsp/LogInCheck.jsp"
    var result = 0
    
    
    func downloadItems(userInformationEmail : String, userInformationPassword : String) {
        let urlAdd = "?userInformationEmail=\(userInformationEmail)&userInformationPassword=\(userInformationPassword)"
        urlPath = urlPath+urlAdd
        let url = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url){(data, response, error)in
            if error != nil{
                print("Failed to download data")
            }else{
                print("Data is downloading")
                self.parseJSON(data!)
            }
        }
        task.resume()
    }
    func parseJSON(_ data: Data) {
        var jsonResult = NSArray()
        
        do{
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSArray
        }catch let error as NSError{
            print(error)
        }
        
        var jsonElement = NSDictionary()
        
        for i in 0..<jsonResult.count{
            
            jsonElement = jsonResult[i] as! NSDictionary
            print(jsonElement)
            
            if let count = jsonElement["result"] as? Int{
                result = count
                print("count : \(count)")
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: self.result)
        })
    }
}
