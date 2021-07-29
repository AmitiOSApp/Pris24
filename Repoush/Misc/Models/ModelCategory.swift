//
//  ModelCategory.swift
//  Repoush
//
//  Created by mac  on 29/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation

class ModelCategory : NSObject, NSCoding{

    var categoryData : [ModelCategoryDatum]!
    var message : String!
    var responseCode : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        categoryData = [ModelCategoryDatum]()
        if let categoryDataArray = dictionary["category_data"] as? [[String:Any]]{
            for dic in categoryDataArray{
                let value = ModelCategoryDatum(fromDictionary: dic)
                categoryData.append(value)
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
        if categoryData != nil{
            var dictionaryElements = [[String:Any]]()
            for categoryDataElement in categoryData {
                dictionaryElements.append(categoryDataElement.toDictionary())
            }
            dictionary["categoryData"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoryData = aDecoder.decodeObject(forKey: "category_data") as? [ModelCategoryDatum]
        message = aDecoder.decodeObject(forKey: "message") as? String
        responseCode = aDecoder.decodeObject(forKey: "responseCode") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if categoryData != nil{
            aCoder.encode(categoryData, forKey: "category_data")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if responseCode != nil{
            aCoder.encode(responseCode, forKey: "responseCode")
        }
    }
}
class ModelCategoryDatum : NSObject, NSCoding{

    var categoryImage : String!
    var categoryName : String!
    var createdAt : String!
    var id : String!
    var isSeleted : Bool!
    var ordering : String!
    var status : String!
    var subcategoryStatus : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        categoryImage = dictionary["category_image"] as? String
        categoryName = dictionary["category_name"] as? String
        createdAt = dictionary["created_at"] as? String
        id = dictionary["id"] as? String
        isSeleted = dictionary["isSeleted"] as? Bool
        ordering = dictionary["ordering"] as? String
        status = dictionary["status"] as? String
        subcategoryStatus = dictionary["subcategory_status"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if categoryImage != nil{
            dictionary["category_image"] = categoryImage
        }
        if categoryName != nil{
            dictionary["category_name"] = categoryName
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isSeleted != nil{
            dictionary["isSeleted"] = isSeleted
        }
        if ordering != nil{
            dictionary["ordering"] = ordering
        }
        if status != nil{
            dictionary["status"] = status
        }
        if subcategoryStatus != nil{
            dictionary["subcategory_status"] = subcategoryStatus
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoryImage = aDecoder.decodeObject(forKey: "category_image") as? String
        categoryName = aDecoder.decodeObject(forKey: "category_name") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        isSeleted = aDecoder.decodeObject(forKey: "isSeleted") as? Bool
        ordering = aDecoder.decodeObject(forKey: "ordering") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        subcategoryStatus = aDecoder.decodeObject(forKey: "subcategory_status") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if categoryImage != nil{
            aCoder.encode(categoryImage, forKey: "category_image")
        }
        if categoryName != nil{
            aCoder.encode(categoryName, forKey: "category_name")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isSeleted != nil{
            aCoder.encode(isSeleted, forKey: "isSeleted")
        }
        if ordering != nil{
            aCoder.encode(ordering, forKey: "ordering")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if subcategoryStatus != nil{
            aCoder.encode(subcategoryStatus, forKey: "subcategory_status")
        }
    }
}
