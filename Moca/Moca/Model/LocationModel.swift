//
//  LocationModel.swift
//  Moca
//
//  Created by 김대환 on 2021/03/07.
//

import Foundation

class Locations: NSObject {
    
    // Properties
    var cafeNames: String?
    var cafeAddress: String?
    var cafePhone: String?
    
    // Empty constructor
    override init() {
        
    }
    
    init(cafeNames: String, cafeAddress: String, cafePhone : String) {
        self.cafeNames = cafeNames
        self.cafeAddress = cafeAddress
        self.cafePhone = cafePhone
    }
}
