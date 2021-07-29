//
//  ModelBuyerProfileHistory.swift
//  Repoush
//
//  Created by mac  on 21/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation

class ModelBuyerProfileHistory : NSObject, NSCoding{

    var message : String!
    var responseCode : Int!
    var responseData : [ModelBuyerProfileModelResponseDatum]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        responseData = [ModelBuyerProfileModelResponseDatum]()
        if let responseDataArray = dictionary["responseData"] as? [[String:Any]]{
            for dic in responseDataArray{
                let value = ModelBuyerProfileModelResponseDatum(fromDictionary: dic)
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
        responseData = aDecoder.decodeObject(forKey: "responseData") as? [ModelBuyerProfileModelResponseDatum]
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
class ModelBuyerProfileModelResponseDatum : NSObject, NSCoding{

    var address : String!
    var basePrice : String!
    var bidAmount : String!
    var brand : String!
    var categoryName : String!
    var commentCount : Int!
    var companyName : String!
    var descriptionField : String!
    var discount : String!
    var distance : Float!
    var firstName : String!
    var isRated : Int!
    var lastName : String!
    var latitude : String!
    var lognitute : String!
    var offerPrice : String!
    var orderStatus : String!
    var orderType : String!
    var productCondition : String!
    var productId : String!
    var productImage : [ModelBuyerProfileHistoryProductImage]!
    var productName : String!
    var productProperty : [ModelBuyerProfileHistoryProductProperty]!
    var rating : String!
    var ratingList : [ModeBuyerProfileHistorylRatingList]!
    var review : Int!
    var role : String!
    var sellerId : String!
    var sellerLatitude : String!
    var sellerLognitude : String!
    var subcategoryName : String!
    var userImage : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        address = dictionary["address"] as? String
        basePrice = dictionary["base_price"] as? String
        bidAmount = dictionary["bid_amount"] as? String
        brand = dictionary["brand"] as? String
        categoryName = dictionary["category_name"] as? String
        commentCount = dictionary["comment_count"] as? Int
        companyName = dictionary["company_name"] as? String
        descriptionField = dictionary["description"] as? String
        discount = dictionary["discount"] as? String
        distance = dictionary["distance"] as? Float
        firstName = dictionary["first_name"] as? String
        isRated = dictionary["is_rated"] as? Int
        lastName = dictionary["last_name"] as? String
        latitude = dictionary["latitude"] as? String
        lognitute = dictionary["lognitute"] as? String
        offerPrice = dictionary["offer_price"] as? String
        orderStatus = dictionary["order_status"] as? String
        orderType = dictionary["order_type"] as? String
        productCondition = dictionary["product_condition"] as? String
        productId = dictionary["product_id"] as? String
        productName = dictionary["product_name"] as? String
        rating = dictionary["rating"] as? String
        review = dictionary["review"] as? Int
        role = dictionary["role"] as? String
        sellerId = dictionary["seller_id"] as? String
        sellerLatitude = dictionary["seller_latitude"] as? String
        sellerLognitude = dictionary["seller_lognitude"] as? String
        subcategoryName = dictionary["subcategory_name"] as? String
        userImage = dictionary["user_image"] as? String
        productImage = [ModelBuyerProfileHistoryProductImage]()
        if let productImageArray = dictionary["product_image"] as? [[String:Any]]{
            for dic in productImageArray{
                let value = ModelBuyerProfileHistoryProductImage(fromDictionary: dic)
                productImage.append(value)
            }
        }
        productProperty = [ModelBuyerProfileHistoryProductProperty]()
        if let productPropertyArray = dictionary["product_property"] as? [[String:Any]]{
            for dic in productPropertyArray{
                let value = ModelBuyerProfileHistoryProductProperty(fromDictionary: dic)
                productProperty.append(value)
            }
        }
        ratingList = [ModeBuyerProfileHistorylRatingList]()
        if let ratingListArray = dictionary["rating_list"] as? [[String:Any]]{
            for dic in ratingListArray{
                let value = ModeBuyerProfileHistorylRatingList(fromDictionary: dic)
                ratingList.append(value)
            }
        }
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
        if basePrice != nil{
            dictionary["base_price"] = basePrice
        }
        if bidAmount != nil{
            dictionary["bid_amount"] = bidAmount
        }
        if brand != nil{
            dictionary["brand"] = brand
        }
        if categoryName != nil{
            dictionary["category_name"] = categoryName
        }
        if commentCount != nil{
            dictionary["comment_count"] = commentCount
        }
        if companyName != nil{
            dictionary["company_name"] = companyName
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if discount != nil{
            dictionary["discount"] = discount
        }
        if distance != nil{
            dictionary["distance"] = distance
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if isRated != nil{
            dictionary["is_rated"] = isRated
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
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
        if orderType != nil{
            dictionary["order_type"] = orderType
        }
        if productCondition != nil{
            dictionary["product_condition"] = productCondition
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if productName != nil{
            dictionary["product_name"] = productName
        }
        if rating != nil{
            dictionary["rating"] = rating
        }
        if review != nil{
            dictionary["review"] = review
        }
        if role != nil{
            dictionary["role"] = role
        }
        if sellerId != nil{
            dictionary["seller_id"] = sellerId
        }
        if sellerLatitude != nil{
            dictionary["seller_latitude"] = sellerLatitude
        }
        if sellerLognitude != nil{
            dictionary["seller_lognitude"] = sellerLognitude
        }
        if subcategoryName != nil{
            dictionary["subcategory_name"] = subcategoryName
        }
        if userImage != nil{
            dictionary["user_image"] = userImage
        }
        if productImage != nil{
            var dictionaryElements = [[String:Any]]()
            for productImageElement in productImage {
                dictionaryElements.append(productImageElement.toDictionary())
            }
            dictionary["productImage"] = dictionaryElements
        }
        if productProperty != nil{
            var dictionaryElements = [[String:Any]]()
            for productPropertyElement in productProperty {
                dictionaryElements.append(productPropertyElement.toDictionary())
            }
            dictionary["productProperty"] = dictionaryElements
        }
        if ratingList != nil{
            var dictionaryElements = [[String:Any]]()
            for ratingListElement in ratingList {
                dictionaryElements.append(ratingListElement.toDictionary())
            }
            dictionary["ratingList"] = dictionaryElements
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
        basePrice = aDecoder.decodeObject(forKey: "base_price") as? String
        bidAmount = aDecoder.decodeObject(forKey: "bid_amount") as? String
        brand = aDecoder.decodeObject(forKey: "brand") as? String
        categoryName = aDecoder.decodeObject(forKey: "category_name") as? String
        commentCount = aDecoder.decodeObject(forKey: "comment_count") as? Int
        companyName = aDecoder.decodeObject(forKey: "company_name") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        discount = aDecoder.decodeObject(forKey: "discount") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? Float
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        isRated = aDecoder.decodeObject(forKey: "is_rated") as? Int
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        lognitute = aDecoder.decodeObject(forKey: "lognitute") as? String
        offerPrice = aDecoder.decodeObject(forKey: "offer_price") as? String
        orderStatus = aDecoder.decodeObject(forKey: "order_status") as? String
        orderType = aDecoder.decodeObject(forKey: "order_type") as? String
        productCondition = aDecoder.decodeObject(forKey: "product_condition") as? String
        productId = aDecoder.decodeObject(forKey: "product_id") as? String
        productImage = aDecoder.decodeObject(forKey: "product_image") as? [ModelBuyerProfileHistoryProductImage]
        productName = aDecoder.decodeObject(forKey: "product_name") as? String
        productProperty = aDecoder.decodeObject(forKey: "product_property") as? [ModelBuyerProfileHistoryProductProperty]
        rating = aDecoder.decodeObject(forKey: "rating") as? String
        ratingList = aDecoder.decodeObject(forKey: "rating_list") as? [ModeBuyerProfileHistorylRatingList]
        review = aDecoder.decodeObject(forKey: "review") as? Int
        role = aDecoder.decodeObject(forKey: "role") as? String
        sellerId = aDecoder.decodeObject(forKey: "seller_id") as? String
        sellerLatitude = aDecoder.decodeObject(forKey: "seller_latitude") as? String
        sellerLognitude = aDecoder.decodeObject(forKey: "seller_lognitude") as? String
        subcategoryName = aDecoder.decodeObject(forKey: "subcategory_name") as? String
        userImage = aDecoder.decodeObject(forKey: "user_image") as? String
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
        if basePrice != nil{
            aCoder.encode(basePrice, forKey: "base_price")
        }
        if bidAmount != nil{
            aCoder.encode(bidAmount, forKey: "bid_amount")
        }
        if brand != nil{
            aCoder.encode(brand, forKey: "brand")
        }
        if categoryName != nil{
            aCoder.encode(categoryName, forKey: "category_name")
        }
        if commentCount != nil{
            aCoder.encode(commentCount, forKey: "comment_count")
        }
        if companyName != nil{
            aCoder.encode(companyName, forKey: "company_name")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if discount != nil{
            aCoder.encode(discount, forKey: "discount")
        }
        if distance != nil{
            aCoder.encode(distance, forKey: "distance")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if isRated != nil{
            aCoder.encode(isRated, forKey: "is_rated")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
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
        if orderType != nil{
            aCoder.encode(orderType, forKey: "order_type")
        }
        if productCondition != nil{
            aCoder.encode(productCondition, forKey: "product_condition")
        }
        if productId != nil{
            aCoder.encode(productId, forKey: "product_id")
        }
        if productImage != nil{
            aCoder.encode(productImage, forKey: "product_image")
        }
        if productName != nil{
            aCoder.encode(productName, forKey: "product_name")
        }
        if productProperty != nil{
            aCoder.encode(productProperty, forKey: "product_property")
        }
        if rating != nil{
            aCoder.encode(rating, forKey: "rating")
        }
        if ratingList != nil{
            aCoder.encode(ratingList, forKey: "rating_list")
        }
        if review != nil{
            aCoder.encode(review, forKey: "review")
        }
        if role != nil{
            aCoder.encode(role, forKey: "role")
        }
        if sellerId != nil{
            aCoder.encode(sellerId, forKey: "seller_id")
        }
        if sellerLatitude != nil{
            aCoder.encode(sellerLatitude, forKey: "seller_latitude")
        }
        if sellerLognitude != nil{
            aCoder.encode(sellerLognitude, forKey: "seller_lognitude")
        }
        if subcategoryName != nil{
            aCoder.encode(subcategoryName, forKey: "subcategory_name")
        }
        if userImage != nil{
            aCoder.encode(userImage, forKey: "user_image")
        }
    }
}
class ModeBuyerProfileHistorylRatingList : NSObject, NSCoding{

    var feedbackDate : String!
    var feedbackMessage : String!
    var firstName : String!
    var id : String!
    var lastName : String!
    var productId : String!
    var rating : String!
    var ratingFor : String!
    var status : String!
    var userId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        feedbackDate = dictionary["feedback_date"] as? String
        feedbackMessage = dictionary["feedback_message"] as? String
        firstName = dictionary["first_name"] as? String
        id = dictionary["id"] as? String
        lastName = dictionary["last_name"] as? String
        productId = dictionary["product_id"] as? String
        rating = dictionary["rating"] as? String
        ratingFor = dictionary["rating_for"] as? String
        status = dictionary["status"] as? String
        userId = dictionary["user_id"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if feedbackDate != nil{
            dictionary["feedback_date"] = feedbackDate
        }
        if feedbackMessage != nil{
            dictionary["feedback_message"] = feedbackMessage
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if id != nil{
            dictionary["id"] = id
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if rating != nil{
            dictionary["rating"] = rating
        }
        if ratingFor != nil{
            dictionary["rating_for"] = ratingFor
        }
        if status != nil{
            dictionary["status"] = status
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
        feedbackDate = aDecoder.decodeObject(forKey: "feedback_date") as? String
        feedbackMessage = aDecoder.decodeObject(forKey: "feedback_message") as? String
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        productId = aDecoder.decodeObject(forKey: "product_id") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? String
        ratingFor = aDecoder.decodeObject(forKey: "rating_for") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if feedbackDate != nil{
            aCoder.encode(feedbackDate, forKey: "feedback_date")
        }
        if feedbackMessage != nil{
            aCoder.encode(feedbackMessage, forKey: "feedback_message")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if productId != nil{
            aCoder.encode(productId, forKey: "product_id")
        }
        if rating != nil{
            aCoder.encode(rating, forKey: "rating")
        }
        if ratingFor != nil{
            aCoder.encode(ratingFor, forKey: "rating_for")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
    }
}
class ModelBuyerProfileHistoryProductProperty : NSObject, NSCoding{

    var createdAt : String!
    var id : String!
    var productId : String!
    var propertyId : String!
    var propertyName : String!
    var propertyValue : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? String
        id = dictionary["id"] as? String
        productId = dictionary["product_id"] as? String
        propertyId = dictionary["property_id"] as? String
        propertyName = dictionary["property_name"] as? String
        propertyValue = dictionary["property_value"] as? String
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
        if id != nil{
            dictionary["id"] = id
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if propertyId != nil{
            dictionary["property_id"] = propertyId
        }
        if propertyName != nil{
            dictionary["property_name"] = propertyName
        }
        if propertyValue != nil{
            dictionary["property_value"] = propertyValue
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        productId = aDecoder.decodeObject(forKey: "product_id") as? String
        propertyId = aDecoder.decodeObject(forKey: "property_id") as? String
        propertyName = aDecoder.decodeObject(forKey: "property_name") as? String
        propertyValue = aDecoder.decodeObject(forKey: "property_value") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if productId != nil{
            aCoder.encode(productId, forKey: "product_id")
        }
        if propertyId != nil{
            aCoder.encode(propertyId, forKey: "property_id")
        }
        if propertyName != nil{
            aCoder.encode(propertyName, forKey: "property_name")
        }
        if propertyValue != nil{
            aCoder.encode(propertyValue, forKey: "property_value")
        }
    }
}
class ModelBuyerProfileHistoryProductImage : NSObject, NSCoding{

    var createdAt : String!
    var id : String!
    var productId : String!
    var productImage : String!
    var thumbsProductImage : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? String
        id = dictionary["id"] as? String
        productId = dictionary["product_id"] as? String
        productImage = dictionary["product_image"] as? String
        thumbsProductImage = dictionary["thumbs_product_image"] as? String
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
        if id != nil{
            dictionary["id"] = id
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if productImage != nil{
            dictionary["product_image"] = productImage
        }
        if thumbsProductImage != nil{
            dictionary["thumbs_product_image"] = thumbsProductImage
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        productId = aDecoder.decodeObject(forKey: "product_id") as? String
        productImage = aDecoder.decodeObject(forKey: "product_image") as? String
        thumbsProductImage = aDecoder.decodeObject(forKey: "thumbs_product_image") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if productId != nil{
            aCoder.encode(productId, forKey: "product_id")
        }
        if productImage != nil{
            aCoder.encode(productImage, forKey: "product_image")
        }
        if thumbsProductImage != nil{
            aCoder.encode(thumbsProductImage, forKey: "thumbs_product_image")
        }
    }
}
