//
//  HomeScreenModel.swift
//  ShopNow
//
//  Created by mayank ranka on 01/07/23.
//

import UIKit

class ProductsModel: NSObject {
    
    var id                 : Int?
    var title              : String?
    var descrip            : String?
    var price              : Double?
    var discountPercentage : Double?
    var rating             : Double?
    var stock              : Int?
    var brand              : String?
    var category           : String?
    var thumbnail          : String?
    var images             : [String]?
    
    init(ditionary : [String : Any]) {
        super.init()
        id = ditionary["id"] as? Int
        title = ditionary["title"] as? String
        descrip = ditionary["description"] as? String
        price = ditionary["price"] as? Double
        discountPercentage = ditionary["discountPercentage"] as? Double
        rating = ditionary["rating"] as? Double
        stock = ditionary["stock"] as? Int
        brand = ditionary["brand"] as? String
        category = ditionary["category"] as? String
        thumbnail = ditionary["thumbnail"] as? String
        images = ditionary["images"] as? [String]
    }
}
