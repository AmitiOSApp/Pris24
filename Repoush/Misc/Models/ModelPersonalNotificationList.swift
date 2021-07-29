//
//  ModelPersonalNotificationList.swift
//  Repoush
//
//  Created by Apple on 21/11/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation
class ModelPersonalNotificationList : NSObject, NSCoding{

    var message : String!
    var notificationData : [PersonalModelNotificationDatum]!
    var responseCode : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        notificationData = [PersonalModelNotificationDatum]()
        if let notificationDataArray = dictionary["notification_data"] as? [[String:Any]]{
            for dic in notificationDataArray{
                let value = PersonalModelNotificationDatum(fromDictionary: dic)
                notificationData.append(value)
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
        if notificationData != nil{
            var dictionaryElements = [[String:Any]]()
            for notificationDataElement in notificationData {
                dictionaryElements.append(notificationDataElement.toDictionary())
            }
            dictionary["notificationData"] = dictionaryElements
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
        notificationData = aDecoder.decodeObject(forKey: "notification_data") as? [PersonalModelNotificationDatum]
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
        if notificationData != nil{
            aCoder.encode(notificationData, forKey: "notification_data")
        }
        if responseCode != nil{
            aCoder.encode(responseCode, forKey: "responseCode")
        }
    }
}
class PersonalModelNotificationDatum : NSObject, NSCoding{

    var bidId : String!
    var createdAt : String!
    var id : String!
    var notificationMsg : String!
    var notificationMsgDa : String!
    var ratingFor : String!
    var status : String!
    var title : String!
    var titleDa : String!
    var type : String!
    var userId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        bidId = dictionary["bid_id"] as? String
        createdAt = dictionary["created_at"] as? String
        id = dictionary["id"] as? String
        notificationMsg = dictionary["notification_msg"] as? String
        notificationMsgDa = dictionary["notification_msg_da"] as? String
        ratingFor = dictionary["rating_for"] as? String
        status = dictionary["status"] as? String
        title = dictionary["title"] as? String
        titleDa = dictionary["title_da"] as? String
        type = dictionary["type"] as? String
        userId = dictionary["user_id"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if bidId != nil{
            dictionary["bid_id"] = bidId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if notificationMsg != nil{
            dictionary["notification_msg"] = notificationMsg
        }
        if notificationMsgDa != nil{
            dictionary["notification_msg_da"] = notificationMsgDa
        }
        if ratingFor != nil{
            dictionary["rating_for"] = ratingFor
        }
        if status != nil{
            dictionary["status"] = status
        }
        if title != nil{
            dictionary["title"] = title
        }
        if titleDa != nil{
            dictionary["title_da"] = titleDa
        }
        if type != nil{
            dictionary["type"] = type
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
        bidId = aDecoder.decodeObject(forKey: "bid_id") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        notificationMsg = aDecoder.decodeObject(forKey: "notification_msg") as? String
        notificationMsgDa = aDecoder.decodeObject(forKey: "notification_msg_da") as? String
        ratingFor = aDecoder.decodeObject(forKey: "rating_for") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        titleDa = aDecoder.decodeObject(forKey: "title_da") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if bidId != nil{
            aCoder.encode(bidId, forKey: "bid_id")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if notificationMsg != nil{
            aCoder.encode(notificationMsg, forKey: "notification_msg")
        }
        if notificationMsgDa != nil{
            aCoder.encode(notificationMsgDa, forKey: "notification_msg_da")
        }
        if ratingFor != nil{
            aCoder.encode(ratingFor, forKey: "rating_for")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if titleDa != nil{
            aCoder.encode(titleDa, forKey: "title_da")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
    }
}
