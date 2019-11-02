//
//  Book.swift
//  LitNet
//
//  Created by Igor Karyi on 31.10.2019.
//  Copyright © 2019 IK. All rights reserved.
//

import ObjectMapper

struct Book {
    var id : Int?
    var title : String?
    var authorId : Int?
    var authorName : String?
    var authorAvatarUrl : String?
    var coAuthor : String?
    var coAuthorName : String?
    var coAuthorAvatarUrl : String?
    var pubId : String?
    var pubName : String?
    var type : String?
    var bonusBalancePromocode : Bool?
    var genres : [Genres]?
    var tags : [Tags]?
    var annotation : String?
    var cover : String?
    var createdAt : Int?
    var finishedAt : Int?
    var lastUpdate : Int?
    var adultOnly : Bool?
    var bookActive : Bool?
    var intro : Bool?
    var freeChapters : Int?
    var rating : Int?
    var likes : Int?
    var rewards : Int?
    var views : Int?
    var inLibraries : Int?
    var comments : Int?
    var allowComments : Bool?
    var totalChrLength : Int?
    var pages : Int?
    var price : Int?
    var blocked : Bool?
    var url : String?
    var liked : Bool?
    var rewarded : Bool?
    var status : String?
    var isPurchased : Bool?
    var lang : String?
    var sellingFrozen : Bool?
    var currencyCode : String?
    var authorBooksCount : Int?
    var coAuthorBooksCount : Int?
    var cycleId : Int?
    var cyclePriority : Int?
    var booktrailer : String?
    var tmpAccessSold : String?
    var publisher : String?
}

extension Book: Mappable {

    init?(map: Map) {}

    // Mappable
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        authorId <- map["author_id"]
        authorName <- map["author_name"]
        authorAvatarUrl <- map["author_avatar_url"]
        coAuthor <- map["co_author"]
        coAuthorName <- map["co_author_name"]
        coAuthorAvatarUrl <- map["co_author_avatar_url"]
        pubId <- map["pub_id"]
        pubName <- map["pub_name"]
        type <- map["type"]
        bonusBalancePromocode <- map["bonus_balance_promocode"]
        genres <- map["genres"]
        tags <- map["tags"]
        annotation <- map["annotation"]
        cover <- map["cover"]
        createdAt <- map["created_at"]
        finishedAt <- map["finished_at"]
        lastUpdate <- map["last_update"]
        adultOnly <- map["adult_only"]
        bookActive <- map["book_active"]
        intro <- map["intro"]
        freeChapters <- map["free_chapters"]
        rating <- map["rating"]
        likes <- map["likes"]
        rewards <- map["rewards"]
        views <- map["views"]
        inLibraries <- map["in_libraries"]
        comments <- map["comments"]
        allowComments <- map["allow_comments"]
        totalChrLength <- map["total_chr_length"]
        pages <- map["pages"]
        price <- map["price"]
        blocked <- map["blocked"]
        url <- map["url"]
        liked <- map["liked"]
        rewarded <- map["rewarded"]
        status <- map["status"]
        isPurchased <- map["is_purchased"]
        lang <- map["lang"]
        sellingFrozen <- map["selling_frozen"]
        currencyCode <- map["currency_code"]
        authorBooksCount <- map["author_books_count"]
        coAuthorBooksCount <- map["co_author_books_count"]
        cycleId <- map["cycle_id"]
        cyclePriority <- map["cycle_priority"]
        booktrailer <- map["booktrailer"]
        tmpAccessSold <- map["tmp_access_sold"]
        publisher <- map["publisher"]
    }
    
}
