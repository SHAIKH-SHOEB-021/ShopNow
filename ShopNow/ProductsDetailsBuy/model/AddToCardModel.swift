//
//  AddToCardModel.swift
//  ShopNow
//
//  Created by mayank ranka on 06/07/23.
//

import UIKit

struct AddToCardModel {
    var productId    : String!
    var imageUrl     : String!
    var productTitle : String!
    var productPrice : String!
    var productStock : String!
    var deliveryDate : String!
    var productQuantity  = 1
}

struct OrderDetails {
    var productId       : String!
    var imageUrl        : String!
    var productTitle    : String!
    var productPrice    : String!
    var productQuantity : String!
    var deliveryDate    : String!
}
