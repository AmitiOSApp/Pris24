//
//  ModelViewReceipintList.swift
//  Repoush
//
//  Created by Apple on 12/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation
class ModelViewReceipintList : NSObject, NSCoding{

    var message : String!
    var offerList : [ModelRecipintOfferList]!
    var responseCode : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        offerList = [ModelRecipintOfferList]()
        if let offerListArray = dictionary["offer_list"] as? [[String:Any]]{
            for dic in offerListArray{
                let value = ModelRecipintOfferList(fromDictionary: dic)
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
        offerList = aDecoder.decodeObject(forKey: "offer_list") as? [ModelRecipintOfferList]
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
class ModelRecipintOfferList : NSObject, NSCoding{

    var name : String!
    var recieverId : String!
    var userId : String!
    var userImage : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        name = dictionary["name"] as? String
        recieverId = dictionary["reciever_id"] as? String
        userId = dictionary["user_id"] as? String
        userImage = dictionary["user_image"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if name != nil{
            dictionary["name"] = name
        }
        if recieverId != nil{
            dictionary["reciever_id"] = recieverId
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if userImage != nil{
            dictionary["user_image"] = userImage
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        name = aDecoder.decodeObject(forKey: "name") as? String
        recieverId = aDecoder.decodeObject(forKey: "reciever_id") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
        userImage = aDecoder.decodeObject(forKey: "user_image") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if recieverId != nil{
            aCoder.encode(recieverId, forKey: "reciever_id")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if userImage != nil{
            aCoder.encode(userImage, forKey: "user_image")
        }
    }
}
