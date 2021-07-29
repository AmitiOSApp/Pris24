//
//  ModelProductDetail.swift
//  Repoush
//
//  Created by mac  on 16/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation

class ModelProductDetail : NSObject, NSCoding{

    var message : String!
    var responseCode : Int!
    var responseData : ModelResponseDatum!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        if let responseDataData = dictionary["responseData"] as? [String:Any]{
            responseData = ModelResponseDatum(fromDictionary: responseDataData)
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
            dictionary["responseData"] = responseData.toDictionary()
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
        responseData = aDecoder.decodeObject(forKey: "responseData") as? ModelResponseDatum
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
class ModelResponseDatum : NSObject, NSCoding{

    var accountStatus : String!
    var address : String!
    var addressType : String!
    var auctionTimer : String!
    var basePrice : String!
    var brand : String!
    var categoryId : String!
    var categoryName : String!
    var commentCount : Int!
    var companyName : String!
    var createdAt : String!
    var descriptionField : String!
    var discount : String!
    var distance : Double!
    var firstName : String!
    var id : String!
    var isAlloted : Int!
    var isBooked : String!
    var lastName : String!
    var latitude : String!
    var lognitute : String!
    var offerPrice : String!
    var orderStatus : String!
    var productCondition : String!
    var productImage : [ModelProductImage]!
    var productProperty : [ModelProductProperty]!
    var rating : String!
    var ratingList : [ModelRatingList]!
    var review : Int!
    var role : String!
    var selling : String!
    var status : String!
    var subcategoryId : String!
    var subcategoryName : String!
    var timeLeft : String!
    var timeLeftInSecond : Int!
    var userAddress : String!
    var userEmail : String!
    var userId : String!
    var userImage : String!
    var userPhone : String!
    var productcondition : String!
    
    var username : String!
    var buyeremail : String!
    var buyerfirstname : String!
    var buyerlastname : String!
    var buyermobilenumber : String!
    var buyerusername : String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        accountStatus = dictionary["account_status"] as? String
        address = dictionary["address"] as? String
        addressType = dictionary["address_type"] as? String
        auctionTimer = dictionary["auction_timer"] as? String
        basePrice = dictionary["base_price"] as? String
        brand = dictionary["brand"] as? String
        categoryId = dictionary["category_id"] as? String
        categoryName = dictionary["category_name"] as? String
        commentCount = dictionary["comment_count"] as? Int
        companyName = dictionary["company_name"] as? String
        createdAt = dictionary["created_at"] as? String
        descriptionField = dictionary["description"] as? String
        discount = dictionary["discount"] as? String
        distance = dictionary["distance"] as? Double
        firstName = dictionary["first_name"] as? String
        id = dictionary["id"] as? String
        isAlloted = dictionary["is_alloted"] as? Int
        isBooked = dictionary["is_booked"] as? String
        lastName = dictionary["last_name"] as? String
        latitude = dictionary["latitude"] as? String
        lognitute = dictionary["lognitute"] as? String
        offerPrice = dictionary["offer_price"] as? String
        orderStatus = dictionary["order_status"] as? String
        productCondition = dictionary["product_condition"] as? String
        rating = dictionary["rating"] as? String ?? String(dictionary["rating"] as? Int ?? 0)
        review = dictionary["review"] as? Int
        role = dictionary["role"] as? String
        selling = dictionary["selling"] as? String
        status = dictionary["status"] as? String
        subcategoryId = dictionary["subcategory_id"] as? String
        subcategoryName = dictionary["subcategory_name"] as? String
        timeLeft = dictionary["time_left"] as? String
        timeLeftInSecond = dictionary["time_left_in_second"] as? Int
        userAddress = dictionary["user_address"] as? String
        userEmail = dictionary["user_email"] as? String
        userId = dictionary["user_id"] as? String
        userImage = dictionary["user_image"] as? String
        userPhone = dictionary["user_phone"] as? String
        productcondition = dictionary["product_condition"] as? String
        
        username = dictionary["username"] as? String
        buyeremail = dictionary["buyer_email"] as? String
        buyerfirstname = dictionary["buyer_first_name"] as? String
        buyerlastname = dictionary["buyer_last_name"] as? String
        buyermobilenumber = dictionary["buyer_mobile_number"] as? String
        buyerusername = dictionary["buyer_username"] as? String
        
        
        
    productImage = [ModelProductImage]()
        if let productImageArray = dictionary["product_image"] as? [[String:Any]]{
            for dic in productImageArray{
                let value = ModelProductImage(fromDictionary: dic)
                productImage.append(value)
            }
        }
        productProperty = [ModelProductProperty]()
        if let productPropertyArray = dictionary["product_property"] as? [[String:Any]]{
            for dic in productPropertyArray{
                let value = ModelProductProperty(fromDictionary: dic)
                productProperty.append(value)
            }
        }
        ratingList = [ModelRatingList]()
        if let ratingListArray = dictionary["rating_list"] as? [[String:Any]]{
            for dic in ratingListArray{
                let value = ModelRatingList(fromDictionary: dic)
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
        if accountStatus != nil{
            dictionary["account_status"] = accountStatus
        }
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
        if commentCount != nil{
            dictionary["comment_count"] = commentCount
        }
        if companyName != nil{
            dictionary["company_name"] = companyName
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
        if distance != nil{
            dictionary["distance"] = distance
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
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
        if productCondition != nil{
            dictionary["product_condition"] = productCondition
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
        if timeLeft != nil{
            dictionary["time_left"] = timeLeft
        }
        if timeLeftInSecond != nil{
            dictionary["time_left_in_second"] = timeLeftInSecond
        }
        if userAddress != nil{
            dictionary["user_address"] = userAddress
        }
        if userEmail != nil{
            dictionary["user_email"] = userEmail
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if userImage != nil{
            dictionary["user_image"] = userImage
        }
        if userPhone != nil{
            dictionary["user_phone"] = userPhone
        }
        if userPhone != nil{
            dictionary["product_condition"] = productcondition
        }
        if username != nil{
            dictionary["username"] = username
        }
       
        if buyeremail != nil{
            dictionary["buyer_email"] = buyeremail
        }
        if buyerfirstname != nil{
            dictionary["buyer_first_name"] = buyerfirstname
        }
        if buyerlastname != nil{
            dictionary["buyer_last_name"] = buyerlastname
        }
        if buyermobilenumber != nil{
            dictionary["buyer_mobile_number"] = buyermobilenumber
        }
        if buyerusername != nil{
            dictionary["buyer_username"] = buyerusername
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
        accountStatus = aDecoder.decodeObject(forKey: "account_status") as? String
        address = aDecoder.decodeObject(forKey: "address") as? String
        addressType = aDecoder.decodeObject(forKey: "address_type") as? String
        auctionTimer = aDecoder.decodeObject(forKey: "auction_timer") as? String
        basePrice = aDecoder.decodeObject(forKey: "base_price") as? String
        brand = aDecoder.decodeObject(forKey: "brand") as? String
        categoryId = aDecoder.decodeObject(forKey: "category_id") as? String
        categoryName = aDecoder.decodeObject(forKey: "category_name") as? String
        commentCount = aDecoder.decodeObject(forKey: "comment_count") as? Int
        companyName = aDecoder.decodeObject(forKey: "company_name") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        discount = aDecoder.decodeObject(forKey: "discount") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? Double
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        isAlloted = aDecoder.decodeObject(forKey: "is_alloted") as? Int
        isBooked = aDecoder.decodeObject(forKey: "is_booked") as? String
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        lognitute = aDecoder.decodeObject(forKey: "lognitute") as? String
        offerPrice = aDecoder.decodeObject(forKey: "offer_price") as? String
        orderStatus = aDecoder.decodeObject(forKey: "order_status") as? String
        productCondition = aDecoder.decodeObject(forKey: "product_condition") as? String
        productImage = aDecoder.decodeObject(forKey: "product_image") as? [ModelProductImage]
        productProperty = aDecoder.decodeObject(forKey: "product_property") as? [ModelProductProperty]
        rating = aDecoder.decodeObject(forKey: "rating") as? String
        ratingList = aDecoder.decodeObject(forKey: "rating_list") as? [ModelRatingList]
        review = aDecoder.decodeObject(forKey: "review") as? Int
        role = aDecoder.decodeObject(forKey: "role") as? String
        selling = aDecoder.decodeObject(forKey: "selling") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        subcategoryId = aDecoder.decodeObject(forKey: "subcategory_id") as? String
        subcategoryName = aDecoder.decodeObject(forKey: "subcategory_name") as? String
        timeLeft = aDecoder.decodeObject(forKey: "time_left") as? String
        timeLeftInSecond = aDecoder.decodeObject(forKey: "time_left_in_second") as? Int
        userAddress = aDecoder.decodeObject(forKey: "user_address") as? String
        userEmail = aDecoder.decodeObject(forKey: "user_email") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
        userImage = aDecoder.decodeObject(forKey: "user_image") as? String
        userPhone = aDecoder.decodeObject(forKey: "user_phone") as? String
        productcondition = aDecoder.decodeObject(forKey: "product_condition") as? String
        username = aDecoder.decodeObject(forKey: "username") as? String
        
        buyeremail = aDecoder.decodeObject(forKey: "buyeremail") as? String
        buyerfirstname = aDecoder.decodeObject(forKey: "buyer_first_name") as? String
        buyerlastname = aDecoder.decodeObject(forKey: "buyer_last_name") as? String
        buyermobilenumber = aDecoder.decodeObject(forKey: "buyer_mobile_number") as? String
        buyerusername = aDecoder.decodeObject(forKey: "buyer_username") as? String
       
        
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if accountStatus != nil{
            aCoder.encode(accountStatus, forKey: "account_status")
        }
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
        if commentCount != nil{
            aCoder.encode(commentCount, forKey: "comment_count")
        }
        if companyName != nil{
            aCoder.encode(companyName, forKey: "company_name")
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
        if distance != nil{
            aCoder.encode(distance, forKey: "distance")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
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
        if productCondition != nil{
            aCoder.encode(productCondition, forKey: "product_condition")
        }
        if productImage != nil{
            aCoder.encode(productImage, forKey: "product_image")
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
        if timeLeft != nil{
            aCoder.encode(timeLeft, forKey: "time_left")
        }
        if timeLeftInSecond != nil{
            aCoder.encode(timeLeftInSecond, forKey: "time_left_in_second")
        }
        if userAddress != nil{
            aCoder.encode(userAddress, forKey: "user_address")
        }
        if userEmail != nil{
            aCoder.encode(userEmail, forKey: "user_email")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if userImage != nil{
            aCoder.encode(userImage, forKey: "user_image")
        }
        if userPhone != nil{
            aCoder.encode(userPhone, forKey: "user_phone")
        }
        if productcondition != nil{
            aCoder.encode(productcondition, forKey: "product_condition")
        }
        if username != nil{
            aCoder.encode(username, forKey: "username")
        }
        if buyeremail != nil{
            aCoder.encode(buyeremail, forKey: "buyeremail")
        }
        if buyerfirstname != nil{
            aCoder.encode(username, forKey: "buyer_first_name")
        }
        if buyerlastname != nil{
            aCoder.encode(buyerlastname, forKey: "buyer_last_name")
        }
        if buyermobilenumber != nil{
            aCoder.encode(buyermobilenumber, forKey: "buyer_mobile_number")
        }
        if buyerusername != nil{
            aCoder.encode(buyerusername, forKey: "buyer_username")
        }
    }
}
class ModelRatingList : NSObject, NSCoding{

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
        rating = dictionary["rating"] as? String ?? String(dictionary["rating"] as? Double ?? 0.0)
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
class ModelProductProperty : NSObject, NSCoding{

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
class ModelProductImage : NSObject, NSCoding{

    var id : String!
    var productImage : String!
    var thumbsProductImage : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? String
        productImage = dictionary["product_image"] as? String
        thumbsProductImage = dictionary["thumbs_product_image"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
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
        id = aDecoder.decodeObject(forKey: "id") as? String
        productImage = aDecoder.decodeObject(forKey: "product_image") as? String
        thumbsProductImage = aDecoder.decodeObject(forKey: "thumbs_product_image") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if productImage != nil{
            aCoder.encode(productImage, forKey: "product_image")
        }
        if thumbsProductImage != nil{
            aCoder.encode(thumbsProductImage, forKey: "thumbs_product_image")
        }
    }
}
