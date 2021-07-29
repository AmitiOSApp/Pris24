//
//  ModelAskQuestion.swift
//  Repoush
//
//  Created by Apple on 02/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation

class ModelAskQuestion : NSObject, NSCoding{

    var message : String!
    var responseCode : Int!
    var responseData : [ModelAskQuestionResponseDatum]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        responseData = [ModelAskQuestionResponseDatum]()
        if let responseDataArray = dictionary["responseData"] as? [[String:Any]]{
            for dic in responseDataArray{
                let value = ModelAskQuestionResponseDatum(fromDictionary: dic)
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
        message = aDecoder.decodeObject(forKey: "message") as? String
        responseCode = aDecoder.decodeObject(forKey: "responseCode") as? Int
        responseData = aDecoder.decodeObject(forKey: "responseData") as? [ModelAskQuestionResponseDatum]
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
        if responseCode != nil{
            aCoder.encode(responseCode, forKey: "responseCode")
        }
        if responseData != nil{
            aCoder.encode(responseData, forKey: "responseData")
        }
    }
}
class ModelAskQuestionResponseDatum : NSObject, NSCoding{

    var commentReply : [ModelCommentReply]!
    var createdAt : String!
    var customerImage : String!
    var customerName : String!
    var id : String!
    var message : String!
    var productId : String!
    var sellerId : String!
    var updatedAt : String!
    var userId : String!
    var isSelected = false

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? String
        customerImage = dictionary["customer_image"] as? String
        customerName = dictionary["customer_name"] as? String
        id = dictionary["id"] as? String
        message = dictionary["message"] as? String
        productId = dictionary["product_id"] as? String
        sellerId = dictionary["seller_id"] as? String
        updatedAt = dictionary["updated_at"] as? String
        userId = dictionary["user_id"] as? String
        commentReply = [ModelCommentReply]()
        if let commentReplyArray = dictionary["comment_reply"] as? [[String:Any]]{
            for dic in commentReplyArray{
                let value = ModelCommentReply(fromDictionary: dic)
                commentReply.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if customerImage != nil{
            dictionary["customer_image"] = customerImage
        }
        if customerName != nil{
            dictionary["customer_name"] = customerName
        }
        if id != nil{
            dictionary["id"] = id
        }
        if message != nil{
            dictionary["message"] = message
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if sellerId != nil{
            dictionary["seller_id"] = sellerId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if commentReply != nil{
            var dictionaryElements = [[String:Any]]()
            for commentReplyElement in commentReply {
                dictionaryElements.append(commentReplyElement.toDictionary())
            }
            dictionary["commentReply"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        commentReply = aDecoder.decodeObject(forKey: "comment_reply") as? [ModelCommentReply]
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        customerImage = aDecoder.decodeObject(forKey: "customer_image") as? String
        customerName = aDecoder.decodeObject(forKey: "customer_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
        productId = aDecoder.decodeObject(forKey: "product_id") as? String
        sellerId = aDecoder.decodeObject(forKey: "seller_id") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if commentReply != nil{
            aCoder.encode(commentReply, forKey: "comment_reply")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if customerImage != nil{
            aCoder.encode(customerImage, forKey: "customer_image")
        }
        if customerName != nil{
            aCoder.encode(customerName, forKey: "customer_name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if productId != nil{
            aCoder.encode(productId, forKey: "product_id")
        }
        if sellerId != nil{
            aCoder.encode(sellerId, forKey: "seller_id")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
    }
}
class ModelCommentReply : NSObject, NSCoding{

    var commentId : String!
    var createdAt : String!
    var id : String!
    var replyMessage : String!
    var sellerImage : String!
    var sellerName : String!
    var updatedAt : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        commentId = dictionary["comment_id"] as? String
        createdAt = dictionary["created_at"] as? String
        id = dictionary["id"] as? String
        replyMessage = dictionary["reply_message"] as? String
        sellerImage = dictionary["seller_image"] as? String
        sellerName = dictionary["seller_name"] as? String
        updatedAt = dictionary["updated_at"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if commentId != nil{
            dictionary["comment_id"] = commentId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if replyMessage != nil{
            dictionary["reply_message"] = replyMessage
        }
        if sellerImage != nil{
            dictionary["seller_image"] = sellerImage
        }
        if sellerName != nil{
            dictionary["seller_name"] = sellerName
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        commentId = aDecoder.decodeObject(forKey: "comment_id") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        replyMessage = aDecoder.decodeObject(forKey: "reply_message") as? String
        sellerImage = aDecoder.decodeObject(forKey: "seller_image") as? String
        sellerName = aDecoder.decodeObject(forKey: "seller_name") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if commentId != nil{
            aCoder.encode(commentId, forKey: "comment_id")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if replyMessage != nil{
            aCoder.encode(replyMessage, forKey: "reply_message")
        }
        if sellerImage != nil{
            aCoder.encode(sellerImage, forKey: "seller_image")
        }
        if sellerName != nil{
            aCoder.encode(sellerName, forKey: "seller_name")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
    }
}
