//
//  ModelReceivedNotification.swift
//  Repoush
//
//  Created by Apple on 12/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation

class ModelReceivedNotification : NSObject, NSCoding{

    var message : String!
    var offerList : [ModelReceivesdOfferList]!
    var responseCode : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        offerList = [ModelReceivesdOfferList]()
        if let offerListArray = dictionary["offer_list"] as? [[String:Any]]{
            for dic in offerListArray{
                let value = ModelReceivesdOfferList(fromDictionary: dic)
                offerList.append(value)
            }
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
        if offerList != nil{
            var dictionaryElements = [[String:Any]]()
            for offerListElement in offerList {
                dictionaryElements.append(offerListElement.toDictionary())
            }
            dictionary["offerList"] = dictionaryElements
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
        offerList = aDecoder.decodeObject(forKey: "offer_list") as? [ModelReceivesdOfferList]
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
        if offerList != nil{
            aCoder.encode(offerList, forKey: "offer_list")
        }
        if responseCode != nil{
            aCoder.encode(responseCode, forKey: "responseCode")
        }
    }
}

class ModelReceivesdOfferList : NSObject, NSCoding{

    var buyerName : String!
    var createdAt : String!
    var discountPercentage : String!
    var endTime : String!
    var id : String!
    var itemName : String!
    var notificationMsg : String!
    var productId : String!
    var recieverId : String!
    var sellerName : String!
    var senderId : String!
    var startTime : String!
    var status : String!
    var storeAddress : String!
    var title : String!
    var type : String!
    var validUntil : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        buyerName = dictionary["buyer_name"] as? String
        createdAt = dictionary["created_at"] as? String
        discountPercentage = dictionary["discount_percentage"] as? String
        endTime = dictionary["end_time"] as? String
        id = dictionary["id"] as? String
        itemName = dictionary["item_name"] as? String
        notificationMsg = dictionary["notification_msg"] as? String
        productId = dictionary["product_id"] as? String
        recieverId = dictionary["reciever_id"] as? String
        sellerName = dictionary["seller_name"] as? String
        senderId = dictionary["sender_id"] as? String
        startTime = dictionary["start_time"] as? String
        status = dictionary["status"] as? String
        storeAddress = dictionary["store_address"] as? String
        title = dictionary["title"] as? String
        type = dictionary["type"] as? String
        validUntil = dictionary["valid_until"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if buyerName != nil{
            dictionary["buyer_name"] = buyerName
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if discountPercentage != nil{
            dictionary["discount_percentage"] = discountPercentage
        }
        if endTime != nil{
            dictionary["end_time"] = endTime
        }
        if id != nil{
            dictionary["id"] = id
        }
        if itemName != nil{
            dictionary["item_name"] = itemName
        }
        if notificationMsg != nil{
            dictionary["notification_msg"] = notificationMsg
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if recieverId != nil{
            dictionary["reciever_id"] = recieverId
        }
        if sellerName != nil{
            dictionary["seller_name"] = sellerName
        }
        if senderId != nil{
            dictionary["sender_id"] = senderId
        }
        if startTime != nil{
            dictionary["start_time"] = startTime
        }
        if status != nil{
            dictionary["status"] = status
        }
        if storeAddress != nil{
            dictionary["store_address"] = storeAddress
        }
        if title != nil{
            dictionary["title"] = title
        }
        if type != nil{
            dictionary["type"] = type
        }
        if validUntil != nil{
            dictionary["valid_until"] = validUntil
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        buyerName = aDecoder.decodeObject(forKey: "buyer_name") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        discountPercentage = aDecoder.decodeObject(forKey: "discount_percentage") as? String
        endTime = aDecoder.decodeObject(forKey: "end_time") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        itemName = aDecoder.decodeObject(forKey: "item_name") as? String
        notificationMsg = aDecoder.decodeObject(forKey: "notification_msg") as? String
        productId = aDecoder.decodeObject(forKey: "product_id") as? String
        recieverId = aDecoder.decodeObject(forKey: "reciever_id") as? String
        sellerName = aDecoder.decodeObject(forKey: "seller_name") as? String
        senderId = aDecoder.decodeObject(forKey: "sender_id") as? String
        startTime = aDecoder.decodeObject(forKey: "start_time") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        storeAddress = aDecoder.decodeObject(forKey: "store_address") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        validUntil = aDecoder.decodeObject(forKey: "valid_until") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if buyerName != nil{
            aCoder.encode(buyerName, forKey: "buyer_name")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if discountPercentage != nil{
            aCoder.encode(discountPercentage, forKey: "discount_percentage")
        }
        if endTime != nil{
            aCoder.encode(endTime, forKey: "end_time")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if itemName != nil{
            aCoder.encode(itemName, forKey: "item_name")
        }
        if notificationMsg != nil{
            aCoder.encode(notificationMsg, forKey: "notification_msg")
        }
        if productId != nil{
            aCoder.encode(productId, forKey: "product_id")
        }
        if recieverId != nil{
            aCoder.encode(recieverId, forKey: "reciever_id")
        }
        if sellerName != nil{
            aCoder.encode(sellerName, forKey: "seller_name")
        }
        if senderId != nil{
            aCoder.encode(senderId, forKey: "sender_id")
        }
        if startTime != nil{
            aCoder.encode(startTime, forKey: "start_time")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if storeAddress != nil{
            aCoder.encode(storeAddress, forKey: "store_address")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if validUntil != nil{
            aCoder.encode(validUntil, forKey: "valid_until")
        }
    }
}
