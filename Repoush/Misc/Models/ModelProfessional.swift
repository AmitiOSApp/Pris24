//
//  ModelProfessional.swift
//  Repoush
//
//  Created by mac  on 25/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation

class ModelProfessional : NSObject, NSCoding{

    var message : String!
    var responseCode : Int!
    var responseData : [ModelProfessionalResponseDatum]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        responseData = [ModelProfessionalResponseDatum]()
        if let responseDataArray = dictionary["responseData"] as? [[String:Any]]{
            for dic in responseDataArray{
                let value = ModelProfessionalResponseDatum(fromDictionary: dic)
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
        responseData = aDecoder.decodeObject(forKey: "responseData") as? [ModelProfessionalResponseDatum]
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
class ModelProfessionalResponseDatum : NSObject, NSCoding{

    var accountStatus : String!
    var address : String!
    var addressType : String!
    var auctionTimer : String!
    var basePrice : String!
    var brand : String!
    var categoryId : String!
    var commentCount : Int!
    var companyName : String!
    var createdAt : String!
    var descriptionField : String!
    var discount : String!
    var distance : String!
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
    var productImage : [ModelProfessionalProductImage]!
    var productProperty : String!
    var rating : Int!
    var ratingList : String!
    var review : Int!
    var role : String!
    var sellerLatitude : String!
    var sellerLognitude : String!
    var selling : String!
    var status : String!
    var subcategoryId : String!
    var timeLeft : String!
    var timeLeftInSecond : Int!
    var userAddress : String!
    var userEmail : String!
    var userId : String!
    var userImage : String!
    var userPhone : String!
    var city : String!


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
        commentCount = dictionary["comment_count"] as? Int
        companyName = dictionary["company_name"] as? String
        createdAt = dictionary["created_at"] as? String
        descriptionField = dictionary["description"] as? String
        discount = dictionary["discount"] as? String
        distance = dictionary["distance"] as? String ?? String(dictionary["distance"] as? Double ?? 0.0)
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
        productProperty = dictionary["product_property"] as? String
        rating = dictionary["rating"] as? Int
        ratingList = dictionary["rating_list"] as? String
        review = dictionary["review"] as? Int
        role = dictionary["role"] as? String
        sellerLatitude = dictionary["seller_latitude"] as? String
        sellerLognitude = dictionary["seller_lognitude"] as? String
        selling = dictionary["selling"] as? String
        status = dictionary["status"] as? String
        subcategoryId = dictionary["subcategory_id"] as? String
        timeLeft = dictionary["time_left"] as? String
        timeLeftInSecond = dictionary["time_left_in_second"] as? Int
        userAddress = dictionary["user_address"] as? String
        userEmail = dictionary["user_email"] as? String
        userId = dictionary["user_id"] as? String
        userImage = dictionary["user_image"] as? String
        userPhone = dictionary["user_phone"] as? String
        city = dictionary["city"] as? String
        productImage = [ModelProfessionalProductImage]()
        if let productImageArray = dictionary["product_image"] as? [[String:Any]]{
            for dic in productImageArray{
                let value = ModelProfessionalProductImage(fromDictionary: dic)
                productImage.append(value)
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
        if productProperty != nil{
            dictionary["product_property"] = productProperty
        }
        if rating != nil{
            dictionary["rating"] = rating
        }
        if ratingList != nil{
            dictionary["rating_list"] = ratingList
        }
        if review != nil{
            dictionary["review"] = review
        }
        if role != nil{
            dictionary["role"] = role
        }
        if sellerLatitude != nil{
            dictionary["seller_latitude"] = sellerLatitude
        }
        if sellerLognitude != nil{
            dictionary["seller_lognitude"] = sellerLognitude
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
        if city != nil{
            dictionary["city"] = city
        }
        if productImage != nil{
            var dictionaryElements = [[String:Any]]()
            for productImageElement in productImage {
                dictionaryElements.append(productImageElement.toDictionary())
            }
            dictionary["productImage"] = dictionaryElements
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
        commentCount = aDecoder.decodeObject(forKey: "comment_count") as? Int
        companyName = aDecoder.decodeObject(forKey: "company_name") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        discount = aDecoder.decodeObject(forKey: "discount") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? String
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
        productImage = aDecoder.decodeObject(forKey: "product_image") as? [ModelProfessionalProductImage]
        productProperty = aDecoder.decodeObject(forKey: "product_property") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? Int
        ratingList = aDecoder.decodeObject(forKey: "rating_list") as? String
        review = aDecoder.decodeObject(forKey: "review") as? Int
        role = aDecoder.decodeObject(forKey: "role") as? String
        sellerLatitude = aDecoder.decodeObject(forKey: "seller_latitude") as? String
        sellerLognitude = aDecoder.decodeObject(forKey: "seller_lognitude") as? String
        selling = aDecoder.decodeObject(forKey: "selling") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        subcategoryId = aDecoder.decodeObject(forKey: "subcategory_id") as? String
        timeLeft = aDecoder.decodeObject(forKey: "time_left") as? String
        timeLeftInSecond = aDecoder.decodeObject(forKey: "time_left_in_second") as? Int
        userAddress = aDecoder.decodeObject(forKey: "user_address") as? String
        userEmail = aDecoder.decodeObject(forKey: "user_email") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
        userImage = aDecoder.decodeObject(forKey: "user_image") as? String
        userPhone = aDecoder.decodeObject(forKey: "user_phone") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
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
        if sellerLatitude != nil{
            aCoder.encode(sellerLatitude, forKey: "seller_latitude")
        }
        if sellerLognitude != nil{
            aCoder.encode(sellerLognitude, forKey: "seller_lognitude")
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
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
    }
}
class ModelProfessionalProductImage : NSObject, NSCoding{

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
