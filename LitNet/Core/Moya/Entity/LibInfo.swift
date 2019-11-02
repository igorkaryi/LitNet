//
//  LibInfo.swift
//  LitNet
//
//  Created by Igor Karyi on 31.10.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import ObjectMapper

struct LibInfo {
    var addDate: Int?
    var lastChrCount: Int?
    var type: Int?
}

extension LibInfo: Mappable {
    
    init?(map: Map) {}
    
    // Mappable
    mutating func mapping(map: Map) {
        addDate <- map["add_date"]
        lastChrCount <- map["last_chr_count"]
        type <- map["type"]
    }
    
}
