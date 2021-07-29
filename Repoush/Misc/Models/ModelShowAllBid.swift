//
//  ModelShowAllBid.swift
//  Repoush
//
//  Created by Apple on 24/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation
class ModelShowAllBid : NSObject, NSCoding{

    var bidAccepted : Int!
    var message : String!
    var responseCode : Int!
    var responseData : [ModelShowAllBidResponseDatum]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        bidAccepted = dictionary["bid_accepted"] as? Int
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        responseData = [ModelShowAllBidResponseDatum]()
        if let responseDataArray = dictionary["responseData"] as? [[String:Any]]{
            for dic in responseDataArray{
                let value = ModelShowAllBidResponseDatum(fromDictionary: dic)
                responseData.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bidAccepted != nil{
            dictionary["bid_accepted"] = bidAccepted
        }
        if message != nil{
            dictionary["message"] = message
        }
        if responseCode != nil{
            dictionary["responseCode"] = responseCode
        }
        if responseData != nil{
            var dictionaryElements = [[String:Any]]()
            for responseDataElement in responseData {
                dictionaryElements.append(responseDataElement.toDictionary())
            }
            dictionary["responseData"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        bidAccepted = aDecoder.decodeObject(forKey: "bid_accepted") as? Int
        message = aDecoder.decodeObject(forKey: "message") as? String
        responseCode = aDecoder.decodeObject(forKey: "responseCode") as? Int
        responseData = aDecoder.decodeObject(forKey: "responseData") as? [ModelShowAllBidResponseDatum]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if bidAccepted != nil{
            aCoder.encode(bidAccepted, forKey: "bid_accepted")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if responseCode != nil{
            aCoder.encode(responseCode, forKey: "responseCode")
        }
        if responseData != nil{
            aCoder.encode(responseData, forKey: "responseData")
        }
    }
}
class ModelShowAllBidResponseDatum : NSObject, NSCoding{

    var basePrice : String!
    var bidAmount : String!
    var bidStatus : String!
    var createdAt : String!
    var discount : String!
    var distance : String!
    var fullName : String!
    var id : String!
    var lastLogin : String!
    var offerPrice : String!
    var orderCompleted : String!
    var productId : String!
    var sellerId : String!
    var userId : String!
    var userImg : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        basePrice = dictionary["base_price"] as? String
        bidAmount = dictionary["bid_amount"] as? String
        bidStatus = dictionary["bid_status"] as? String
        createdAt = dictionary["created_at"] as? String
        discount = dictionary["discount"] as? String
        distance = dictionary["distance"] as? String
        fullName = dictionary["full_name"] as? String
        id = dictionary["id"] as? String
        lastLogin = dictionary["last_login"] as? String
        offerPrice = dictionary["offer_price"] as? String
        orderCompleted = dictionary["order_completed"] as? String
        productId = dictionary["product_id"] as? String
        sellerId = dictionary["seller_id"] as? String
        userId = dictionary["user_id"] as? String
        userImg = dictionary["user_img"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if basePrice != nil{
            dictionary["base_price"] = basePrice
        }
        if bidAmount != nil{
            dictionary["bid_amount"] = bidAmount
        }
        if bidStatus != nil{
            dictionary["bid_status"] = bidStatus
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if discount != nil{
            dictionary["discount"] = discount
        }
        if distance != nil{
            dictionary["distance"] = distance
        }
        if fullName != nil{
            dictionary["full_name"] = fullName
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lastLogin != nil{
            dictionary["last_login"] = lastLogin
        }
        if offerPrice != nil{
            dictionary["offer_price"] = offerPrice
        }
        if orderCompleted != nil{
            dictionary["order_completed"] = orderCompleted
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if sellerId != nil{
            dictionary["seller_id"] = sellerId
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if userImg != nil{
            dictionary["user_img"] = userImg
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        basePrice = aDecoder.decodeObject(forKey: "base_price") as? String
        bidAmount = aDecoder.decodeObject(forKey: "bid_amount") as? String
        bidStatus = aDecoder.decodeObject(forKey: "bid_status") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        discount = aDecoder.decodeObject(forKey: "discount") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? String
        fullName = aDecoder.decodeObject(forKey: "full_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        lastLogin = aDecoder.decodeObject(forKey: "last_login") as? String
        offerPrice = aDecoder.decodeObject(forKey: "offer_price") as? String
        orderCompleted = aDecoder.decodeObject(forKey: "order_completed") as? String
        productId = aDecoder.decodeObject(forKey: "product_id") as? String
        sellerId = aDecoder.decodeObject(forKey: "seller_id") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
        userImg = aDecoder.decodeObject(forKey: "user_img") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if basePrice != nil{
            aCoder.encode(basePrice, forKey: "base_price")
        }
        if bidAmount != nil{
            aCoder.encode(bidAmount, forKey: "bid_amount")
        }
        if bidStatus != nil{
            aCoder.encode(bidStatus, forKey: "bid_status")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if discount != nil{
            aCoder.encode(discount, forKey: "discount")
        }
        if distance != nil{
            aCoder.encode(distance, forKey: "distance")
        }
        if fullName != nil{
            aCoder.encode(fullName, forKey: "full_name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lastLogin != nil{
            aCoder.encode(lastLogin, forKey: "last_login")
        }
        if offerPrice != nil{
            aCoder.encode(offerPrice, forKey: "offer_price")
        }
        if orderCompleted != nil{
            aCoder.encode(orderCompleted, forKey: "order_completed")
        }
        if productId != nil{
            aCoder.encode(productId, forKey: "product_id")
        }
        if sellerId != nil{
            aCoder.encode(sellerId, forKey: "seller_id")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if userImg != nil{
            aCoder.encode(userImg, forKey: "user_img")
        }
    }
}
