//
//  ModelSendNotification.swift
//  Repoush
//
//  Created by Apple on 09/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation
class ModelSendNotification : NSObject, NSCoding{

    var bidAccepted : Int!
    var message : String!
    var responseCode : Int!
    var responseData : [ModelResponseSendNotificationDatum]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        bidAccepted = dictionary["bid_accepted"] as? Int
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        responseData = [ModelResponseSendNotificationDatum]()
        if let responseDataArray = dictionary["responseData"] as? [[String:Any]]{
            for dic in responseDataArray{
                let value = ModelResponseSendNotificationDatum(fromDictionary: dic)
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
        responseData = aDecoder.decodeObject(forKey: "responseData") as? [ModelResponseSendNotificationDatum]
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
class ModelResponseSendNotificationDatum : NSObject, NSCoding{

    var bidAmount : String!
    var bidStatus : String!
    var createdAt : String!
    var distance : String!
    var fullName : String!
    var id : String!
    var lastLogin : String!
    var orderCompleted : String!
    var productId : String!
    var userId : String!
    var userImg : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        bidAmount = dictionary["bid_amount"] as? String
        bidStatus = dictionary["bid_status"] as? String
        createdAt = dictionary["created_at"] as? String
        distance = dictionary["distance"] as? String
        fullName = dictionary["full_name"] as? String
        id = dictionary["id"] as? String
        lastLogin = dictionary["last_login"] as? String
        orderCompleted = dictionary["order_completed"] as? String
        productId = dictionary["product_id"] as? String
        userId = dictionary["user_id"] as? String
        userImg = dictionary["user_img"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bidAmount != nil{
            dictionary["bid_amount"] = bidAmount
        }
        if bidStatus != nil{
            dictionary["bid_status"] = bidStatus
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
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
        if orderCompleted != nil{
            dictionary["order_completed"] = orderCompleted
        }
        if productId != nil{
            dictionary["product_id"] = productId
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
        bidAmount = aDecoder.decodeObject(forKey: "bid_amount") as? String
        bidStatus = aDecoder.decodeObject(forKey: "bid_status") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? String
        fullName = aDecoder.decodeObject(forKey: "full_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        lastLogin = aDecoder.decodeObject(forKey: "last_login") as? String
        orderCompleted = aDecoder.decodeObject(forKey: "order_completed") as? String
        productId = aDecoder.decodeObject(forKey: "product_id") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
        userImg = aDecoder.decodeObject(forKey: "user_img") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if bidAmount != nil{
            aCoder.encode(bidAmount, forKey: "bid_amount")
        }
        if bidStatus != nil{
            aCoder.encode(bidStatus, forKey: "bid_status")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
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
        if orderCompleted != nil{
            aCoder.encode(orderCompleted, forKey: "order_completed")
        }
        if productId != nil{
            aCoder.encode(productId, forKey: "product_id")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if userImg != nil{
            aCoder.encode(userImg, forKey: "user_img")
        }
    }
}
