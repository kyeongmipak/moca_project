//
//  EmailCheckModel.swift
//  Moca
//
//  Created by 김대환 on 2021/03/04.
//

import Foundation


protocol EmailCheckModelProtocol: class {
    func emailDownloaded(items: Int)
}

class EmailCheckModel: NSObject {
    var delegate : EmailCheckModelProtocol!
    var urlPath = "http://" + Share.macIP + "/moca/jsp/EmailCheck.jsp"
    var result = 0
    
    
    func downloadItems(userInformationEmail : String) {
        let urlAdd = "?userInformationEmail=\(userInformationEmail)"
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
            self.delegate.emailDownloaded(items: self.result)
        })
    }
}
