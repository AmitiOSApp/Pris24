//
//  ModelAddpost.swift
//  Repoush
//
//  Created by Apple on 27/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation
class ModelAddpost : NSObject, NSCoding{

    var message : String!
    var productData : ModelProductDatum!
    var responseCode : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        if let productDataData = dictionary["product_data"] as? [String:Any]{
            productData = ModelProductDatum(fromDictionary: productDataData)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if message != nil{
            dictionary["message"] = message
        }
        if responseCode != nil{
            dictionary["responseCode"] = responseCode
        }
        if productData != nil{
            dictionary["productData"] = productData.toDictionary()
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        message = aDecoder.decodeObject(forKey: "message") as? String
        productData = aDecoder.decodeObject(forKey: "product_data") as? ModelProductDatum
        responseCode = aDecoder.decodeObject(forKey: "responseCode") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if productData != nil{
            aCoder.encode(productData, forKey: "product_data")
        }
        if responseCode != nil{
            aCoder.encode(responseCode, forKey: "responseCode")
        }
    }
}
class ModelProductDatum : NSObject, NSCoding{

    var address : String!
    var addressType : String!
    var auctionTimer : String!
    var basePrice : String!
    var brand : String!
    var categoryId : String!
    var categoryName : String!
    var createdAt : String!
    var descriptionField : String!
    var discount : String!
    var id : String!
    var isAlloted : String!
    var isBooked : String!
    var latitude : String!
    var lognitute : String!
    var offerPrice : String!
    var orderStatus : String!
    var productCondition : String!
    var productExpiryDate : String!
    var productImage : [AnyObject]!
    var propertyData : [AnyObject]!
    var selling : String!
    var status : String!
    var subcategoryId : String!
    var subcategoryName : String!
    var userId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        address = dictionary["address"] as? String
        addressType = dictionary["address_type"] as? String
        auctionTimer = dictionary["auction_timer"] as? String
        basePrice = dictionary["base_price"] as? String
        brand = dictionary["brand"] as? String
        categoryId = dictionary["category_id"] as? String
        categoryName = dictionary["category_name"] as? String
        createdAt = dictionary["created_at"] as? String
        descriptionField = dictionary["description"] as? String
        discount = dictionary["discount"] as? String
        id = dictionary["id"] as? String
        isAlloted = dictionary["is_alloted"] as? String
        isBooked = dictionary["is_booked"] as? String
        latitude = dictionary["latitude"] as? String
        lognitute = dictionary["lognitute"] as? String
        offerPrice = dictionary["offer_price"] as? String
        orderStatus = dictionary["order_status"] as? String
        productCondition = dictionary["product_condition"] as? String
        productExpiryDate = dictionary["product_expiry_date"] as? String
        selling = dictionary["selling"] as? String
        status = dictionary["status"] as? String
        subcategoryId = dictionary["subcategory_id"] as? String
        subcategoryName = dictionary["subcategory_name"] as? String
        userId = dictionary["user_id"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if address != nil{
            dictionary["address"] = address
        }
        if addressType != nil{
            dictionary["address_type"] = addressType
        }
        if auctionTimer != nil{
            dictionary["auction_timer"] = auctionTimer
        }
        if basePrice != nil{
            dictionary["base_price"] = basePrice
        }
        if brand != nil{
            dictionary["brand"] = brand
        }
        if categoryId != nil{
            dictionary["category_id"] = categoryId
        }
        if categoryName != nil{
            dictionary["category_name"] = categoryName
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if discount != nil{
            dictionary["discount"] = discount
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isAlloted != nil{
            dictionary["is_alloted"] = isAlloted
        }
        if isBooked != nil{
            dictionary["is_booked"] = isBooked
        }
        if latitude != nil{
            dictionary["latitude"] = latitude
        }
        if lognitute != nil{
            dictionary["lognitute"] = lognitute
        }
        if offerPrice != nil{
            dictionary["offer_price"] = offerPrice
        }
        if orderStatus != nil{
            dictionary["order_status"] = orderStatus
        }
        if productCondition != nil{
            dictionary["product_condition"] = productCondition
        }
        if productExpiryDate != nil{
            dictionary["product_expiry_date"] = productExpiryDate
        }
        if selling != nil{
            dictionary["selling"] = selling
        }
        if status != nil{
            dictionary["status"] = status
        }
        if subcategoryId != nil{
            dictionary["subcategory_id"] = subcategoryId
        }
        if subcategoryName != nil{
            dictionary["subcategory_name"] = subcategoryName
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        address = aDecoder.decodeObject(forKey: "address") as? String
        addressType = aDecoder.decodeObject(forKey: "address_type") as? String
        auctionTimer = aDecoder.decodeObject(forKey: "auction_timer") as? String
        basePrice = aDecoder.decodeObject(forKey: "base_price") as? String
        brand = aDecoder.decodeObject(forKey: "brand") as? String
        categoryId = aDecoder.decodeObject(forKey: "category_id") as? String
        categoryName = aDecoder.decodeObject(forKey: "category_name") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        discount = aDecoder.decodeObject(forKey: "discount") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        isAlloted = aDecoder.decodeObject(forKey: "is_alloted") as? String
        isBooked = aDecoder.decodeObject(forKey: "is_booked") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        lognitute = aDecoder.decodeObject(forKey: "lognitute") as? String
        offerPrice = aDecoder.decodeObject(forKey: "offer_price") as? String
        orderStatus = aDecoder.decodeObject(forKey: "order_status") as? String
        productCondition = aDecoder.decodeObject(forKey: "product_condition") as? String
        productExpiryDate = aDecoder.decodeObject(forKey: "product_expiry_date") as? String
        productImage = aDecoder.decodeObject(forKey: "product_image") as? [AnyObject]
        propertyData = aDecoder.decodeObject(forKey: "property_data") as? [AnyObject]
        selling = aDecoder.decodeObject(forKey: "selling") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        subcategoryId = aDecoder.decodeObject(forKey: "subcategory_id") as? String
        subcategoryName = aDecoder.decodeObject(forKey: "subcategory_name") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if addressType != nil{
            aCoder.encode(addressType, forKey: "address_type")
        }
        if auctionTimer != nil{
            aCoder.encode(auctionTimer, forKey: "auction_timer")
        }
        if basePrice != nil{
            aCoder.encode(basePrice, forKey: "base_price")
        }
        if brand != nil{
            aCoder.encode(brand, forKey: "brand")
        }
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: "category_id")
        }
        if categoryName != nil{
            aCoder.encode(categoryName, forKey: "category_name")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if discount != nil{
            aCoder.encode(discount, forKey: "discount")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isAlloted != nil{
            aCoder.encode(isAlloted, forKey: "is_alloted")
        }
        if isBooked != nil{
            aCoder.encode(isBooked, forKey: "is_booked")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        if lognitute != nil{
            aCoder.encode(lognitute, forKey: "lognitute")
        }
        if offerPrice != nil{
            aCoder.encode(offerPrice, forKey: "offer_price")
        }
        if orderStatus != nil{
            aCoder.encode(orderStatus, forKey: "order_status")
        }
        if productCondition != nil{
            aCoder.encode(productCondition, forKey: "product_condition")
        }
        if productExpiryDate != nil{
            aCoder.encode(productExpiryDate, forKey: "product_expiry_date")
        }
        if productImage != nil{
            aCoder.encode(productImage, forKey: "product_image")
        }
        if propertyData != nil{
            aCoder.encode(propertyData, forKey: "property_data")
        }
        if selling != nil{
            aCoder.encode(selling, forKey: "selling")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if subcategoryId != nil{
            aCoder.encode(subcategoryId, forKey: "subcategory_id")
        }
        if subcategoryName != nil{
            aCoder.encode(subcategoryName, forKey: "subcategory_name")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
    }
}
