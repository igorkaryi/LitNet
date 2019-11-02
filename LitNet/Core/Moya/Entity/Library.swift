//
//  Library.swift
//  LitNet
//
//  Created by Igor Karyi on 31.10.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import ObjectMapper

struct Library {
    var libInfo: LibInfo?
    var book: Book?
}

extension Library: Mappable {
    
    init?(map: Map) {}
    
    // Mappable
    mutating func mapping(map: Map) {
        libInfo <- map["lib_info"]
        book <- map["book"]
    }
    
}
