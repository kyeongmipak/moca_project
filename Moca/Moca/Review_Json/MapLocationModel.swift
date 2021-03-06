//
//  MapLocationModel.swift
//  Moca
//
//  Created by 김대환 on 2021/03/06.
//

import Foundation

protocol MapLocationModelProtocol: class {
    func itemDownloaded(items: NSArray)
}

class MapLocationModel: NSObject {
    var delegate : MapLocationModelProtocol!
    let urlPath = "http://127.0.0.1:8080/test/AddressSelect.jsp"
    
    func downloadItems() {
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
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            // let query = DBModel()
            print(jsonElement)
            
            if let addressName = jsonElement["addressName"] as? String,
               let addressReal = jsonElement["addressReal"] as? String,
               let addressPhone = jsonElement["addressPhone"] as? String{
                let query = Locations(cafeNames: addressName, cafeAddress: addressReal, cafePhone: addressPhone)
                
                locations.add(query)
            }

        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}
