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
    var urlPath = "http://" + Share.macIP + "/moca/jsp/AddressSelect.jsp"
    
    func downloadItems(brandName : String) {
        let urlAdd = "?brandName=\(brandName)"
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
        let locations = NSMutableArray()
        
        for i in 0..<jsonResult.count{
            jsonElement = jsonResult[i] as! NSDictionary
            // let query = DBModel()
            
            print("jsonElement\(jsonElement)")
            
            if let addressName = jsonElement["cafeName"] as? String,
               let addressReal = jsonElement["cafeAddress"] as? String,
               let addressPhone = jsonElement["cafePhone"] as? String{
                let query = Locations(cafeNames: addressName, cafeAddress: addressReal, cafePhone: addressPhone)
                
                locations.add(query)
            }

        }
        DispatchQueue.main.async(execute: {() -> Void in
            self.delegate.itemDownloaded(items: locations)
        })
    }
}
