//
//  ModelSellerProfileHistory.swift
//  Repoush
//
//  Created by Apple on 20/09/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation

class ModelSellerProfileHistory : NSObject, NSCoding{

    var message : String!
    var responseCode : Int!
    var responseData : [ModelSellerProfileHistoryResponseDatum]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        responseData = [ModelSellerProfileHistoryResponseDatum]()
        if let responseDataArray = dictionary["responseData"] as? [[String:Any]]{
            for dic in responseDataArray{
                let value = ModelSellerProfileHistoryResponseDatum(fromDictionary: dic)
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
        responseData = aDecoder.decodeObject(forKey: "responseData") as? [ModelSellerProfileHistoryResponseDatum]
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
class ModelSellerProfileHistoryResponseDatum : NSObject, NSCoding{

    var address : String!
    var basePrice : String!
    var brand : String!
    var buyerId : String!
    var buyerImage : String!
    var buyerName : String!
    var categoryName : String!
    var commentCount : Int!
    var companyName : String!
    var descriptionField : String!
    var discount : String!
    var distance : Float!
    var firstName : String!
    var isBooked : String!
    var isRated : Int!
    var lastBid : String!
    var lastName : String!
    var latitude : String!
    var lognitute : String!
    var offerPrice : String!
    var productCondition : String!
    var productId : String!
    var productImage : [ModelSellerProfileHistoryProductImage]!
    var productName : String!
    var productProperty : String!
    var rating : Int!
    var ratingList : [AnyObject]!
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
        brand = dictionary["brand"] as? String
        buyerId = dictionary["buyer_id"] as? String
        buyerImage = dictionary["buyer_image"] as? String
        buyerName = dictionary["buyer_name"] as? String
        categoryName = dictionary["category_name"] as? String
        commentCount = dictionary["comment_count"] as? Int
        companyName = dictionary["company_name"] as? String
        descriptionField = dictionary["description"] as? String
        discount = dictionary["discount"] as? String
        distance = dictionary["distance"] as? Float
        firstName = dictionary["first_name"] as? String
        isBooked = dictionary["is_booked"] as? String
        isRated = dictionary["is_rated"] as? Int
        lastBid = dictionary["last_bid"] as? String ?? String(dictionary["last_bid"] as? Int ?? 0)
        lastName = dictionary["last_name"] as? String
        latitude = dictionary["latitude"] as? String
        lognitute = dictionary["lognitute"] as? String
        offerPrice = dictionary["offer_price"] as? String
        productCondition = dictionary["product_condition"] as? String
        productId = dictionary["product_id"] as? String
        productName = dictionary["product_name"] as? String
        productProperty = dictionary["product_property"] as? String
        rating = dictionary["rating"] as? Int
        review = dictionary["review"] as? Int
        role = dictionary["role"] as? String
        sellerId = dictionary["seller_id"] as? String
        sellerLatitude = dictionary["seller_latitude"] as? String
        sellerLognitude = dictionary["seller_lognitude"] as? String
        subcategoryName = dictionary["subcategory_name"] as? String
        userImage = dictionary["user_image"] as? String
        productImage = [ModelSellerProfileHistoryProductImage]()
        if let productImageArray = dictionary["product_image"] as? [[String:Any]]{
            for dic in productImageArray{
                let value = ModelSellerProfileHistoryProductImage(fromDictionary: dic)
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
        if address != nil{
            dictionary["address"] = address
        }
        if basePrice != nil{
            dictionary["base_price"] = basePrice
        }
        if brand != nil{
            dictionary["brand"] = brand
        }
        if buyerId != nil{
            dictionary["buyer_id"] = buyerId
        }
        if buyerImage != nil{
            dictionary["buyer_image"] = buyerImage
        }
        if buyerName != nil{
            dictionary["buyer_name"] = buyerName
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
        if isBooked != nil{
            dictionary["is_booked"] = isBooked
        }
        if isRated != nil{
            dictionary["is_rated"] = isRated
        }
        if lastBid != nil{
            dictionary["last_bid"] = lastBid
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
        if productCondition != nil{
            dictionary["product_condition"] = productCondition
        }
        if productId != nil{
            dictionary["product_id"] = productId
        }
        if productName != nil{
            dictionary["product_name"] = productName
        }
        if productProperty != nil{
            dictionary["product_property"] = productProperty
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
        brand = aDecoder.decodeObject(forKey: "brand") as? String
        buyerId = aDecoder.decodeObject(forKey: "buyer_id") as? String
        buyerImage = aDecoder.decodeObject(forKey: "buyer_image") as? String
        buyerName = aDecoder.decodeObject(forKey: "buyer_name") as? String
        categoryName = aDecoder.decodeObject(forKey: "category_name") as? String
        commentCount = aDecoder.decodeObject(forKey: "comment_count") as? Int
        companyName = aDecoder.decodeObject(forKey: "company_name") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        discount = aDecoder.decodeObject(forKey: "discount") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? Float
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        isBooked = aDecoder.decodeObject(forKey: "is_booked") as? String
        isRated = aDecoder.decodeObject(forKey: "is_rated") as? Int
        lastBid = aDecoder.decodeObject(forKey: "last_bid") as? String
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        lognitute = aDecoder.decodeObject(forKey: "lognitute") as? String
        offerPrice = aDecoder.decodeObject(forKey: "offer_price") as? String
        productCondition = aDecoder.decodeObject(forKey: "product_condition") as? String
        productId = aDecoder.decodeObject(forKey: "product_id") as? String
        productImage = aDecoder.decodeObject(forKey: "product_image") as? [ModelSellerProfileHistoryProductImage]
        productName = aDecoder.decodeObject(forKey: "product_name") as? String
        productProperty = aDecoder.decodeObject(forKey: "product_property") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? Int
        ratingList = aDecoder.decodeObject(forKey: "rating_list") as? [AnyObject]
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
        if brand != nil{
            aCoder.encode(brand, forKey: "brand")
        }
        if buyerId != nil{
            aCoder.encode(buyerId, forKey: "buyer_id")
        }
        if buyerImage != nil{
            aCoder.encode(buyerImage, forKey: "buyer_image")
        }
        if buyerName != nil{
            aCoder.encode(buyerName, forKey: "buyer_name")
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
        if isBooked != nil{
            aCoder.encode(isBooked, forKey: "is_booked")
        }
        if isRated != nil{
            aCoder.encode(isRated, forKey: "is_rated")
        }
        if lastBid != nil{
            aCoder.encode(lastBid, forKey: "last_bid")
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
class ModelSellerProfileHistoryProductImage : NSObject, NSCoding{

    var productImage : String!
    var thumbsProductImage : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        productImage = dictionary["product_image"] as? String
        thumbsProductImage = dictionary["thumbs_product_image"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
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
        productImage = aDecoder.decodeObject(forKey: "product_image") as? String
        thumbsProductImage = aDecoder.decodeObject(forKey: "thumbs_product_image") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if productImage != nil{
            aCoder.encode(productImage, forKey: "product_image")
        }
        if thumbsProductImage != nil{
            aCoder.encode(thumbsProductImage, forKey: "thumbs_product_image")
        }
    }
}
