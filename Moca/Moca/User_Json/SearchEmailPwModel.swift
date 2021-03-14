//
//  SearchEmailPwModel.swift
//  Moca
//
//  Created by 김대환 on 2021/03/05.
//

import Foundation

protocol SearchEmailPwProtocol: class {
    func itemDownloaded(items: String)
}

class SearchEmailPwModel: NSObject {
    var delegate : SearchEmailPwProtocol!
    var result = ""
    
    
    func searchEmailItems(userInformationName : String, userInformationPhone : String) {
        var urlPath = "http://" + Share.macIP + "/moca/jsp/SearchEmail.jsp"
        let urlAdd = "?userInformationName=\(userInformationName)&userInformationPhone=\(userInformationPhone)"
        urlPath = urlPath + urlAdd
        
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
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
    func searchPasswordItems(userInformationEmail : String, userInformationName : String, userInformationPhone : String) {
        var urlPath = "http://" + Share.macIP + "/moca/jsp/SearchPassword.jsp"
        let urlAdd = "?userInformationEmail=\(userInformationEmail)&userInformationName=\(userInformationName)&userInformationPhone=\(userInformationPhone)"
        urlPath = urlPath + urlAdd
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        
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
            
            if let count = jsonElement["result"] as? String{
                result = count
                print("count : \(count)")
            }
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: self.result)
        })
    }
}
