//
//  ModelPropertyList.swift
//  Repoush
//
//  Created by Apple on 30/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation

class ModelPropertyObjList : NSObject, NSCoding{

    var message : String!
    var propertyData : ModelPropertyObjDatum!
    var responseCode : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        if let propertyDataData = dictionary["property_data"] as? [String:Any]{
            propertyData = ModelPropertyObjDatum(fromDictionary: propertyDataData)
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
        if propertyData != nil{
            dictionary["propertyData"] = propertyData.toDictionary()
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
        propertyData = aDecoder.decodeObject(forKey: "property_data") as? ModelPropertyObjDatum
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
        if propertyData != nil{
            aCoder.encode(propertyData, forKey: "property_data")
        }
        if responseCode != nil{
            aCoder.encode(responseCode, forKey: "responseCode")
        }
    }
}
class ModelPropertyObjDatum : NSObject, NSCoding{

    var category : String!
    var createdAt : String!
    var id : String!
    var propertyName : String!
    var propertyValue : String!
    var status : String!
    var subcategory : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        category = dictionary["category"] as? String
        createdAt = dictionary["created_at"] as? String
        id = dictionary["id"] as? String
        propertyName = dictionary["property_name"] as? String
        propertyValue = dictionary["property_value"] as? String
        status = dictionary["status"] as? String
        subcategory = dictionary["subcategory"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if category != nil{
            dictionary["category"] = category
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if propertyName != nil{
            dictionary["property_name"] = propertyName
        }
        if propertyValue != nil{
            dictionary["property_value"] = propertyValue
        }
        if status != nil{
            dictionary["status"] = status
        }
        if subcategory != nil{
            dictionary["subcategory"] = subcategory
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        category = aDecoder.decodeObject(forKey: "category") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        propertyName = aDecoder.decodeObject(forKey: "property_name") as? String
        propertyValue = aDecoder.decodeObject(forKey: "property_value") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        subcategory = aDecoder.decodeObject(forKey: "subcategory") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if category != nil{
            aCoder.encode(category, forKey: "category")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if propertyName != nil{
            aCoder.encode(propertyName, forKey: "property_name")
        }
        if propertyValue != nil{
            aCoder.encode(propertyValue, forKey: "property_value")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if subcategory != nil{
            aCoder.encode(subcategory, forKey: "subcategory")
        }
    }
}
