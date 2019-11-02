//
//  Genres.swift
//  LitNet
//
//  Created by Igor Karyi on 01.11.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import ObjectMapper

struct Genres {
    var id: Int?
    var name: String?
    var ratingPlace: Int?
}

extension Genres: Mappable {
    
    init?(map: Map) {}
    
    // Mappable
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        ratingPlace <- map["rating_place"]
    }
    
}
