//
//  ModelProfile.swift
//  Repoush
//
//  Created by Apple on 05/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation

class ModelProfile : NSObject, NSCoding{

    var message : String!
    var responseCode : Int!
    var responseData : ModelProfileResponseDatum!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        if let responseDataData = dictionary["responseData"] as? [String:Any]{
            responseData = ModelProfileResponseDatum(fromDictionary: responseDataData)
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
        responseData = aDecoder.decodeObject(forKey: "responseData") as? ModelProfileResponseDatum
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
class ModelProfileResponseDatum : NSObject, NSCoding{

    var accountStatus : String!
    var address : String!
    var certificateType : String!
    var city : String!
    var companyName : String!
    var createdAt : String!
    var cvrNumber : String!
    var deviceToken : String!
    var deviceType : String!
    var dob : String!
    var email : String!
    var firstName : String!
    var gender : String!
    var id : String!
    var industryCode : String!
    var lastLogin : String!
    var lastName : String!
    var latitude : String!
    var lognitude : String!
    var mangoPayId : String!
    var mobileNumber : String!
    var otp : String!
    var otpDatetime : String!
    var password : String!
    var permanentLatitude : String!
    var permanentLognitude : String!
    var promoCode : String!
    var rating : String!
    var ratingList : [ModelProfileRatingList]!
    var review : Int!
    var role : String!
    var salt : String!
    var status : String!
    var userImg : String!
    var zipCode : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        accountStatus = dictionary["account_status"] as? String
        address = dictionary["address"] as? String
        certificateType = dictionary["certificate_type"] as? String
        city = dictionary["city"] as? String
        companyName = dictionary["company_name"] as? String
        createdAt = dictionary["created_at"] as? String
        cvrNumber = dictionary["cvr_number"] as? String
        deviceToken = dictionary["device_token"] as? String
        deviceType = dictionary["device_type"] as? String
        dob = dictionary["dob"] as? String
        email = dictionary["email"] as? String
        firstName = dictionary["first_name"] as? String
        gender = dictionary["gender"] as? String
        id = dictionary["id"] as? String
        industryCode = dictionary["industry_code"] as? String
        lastLogin = dictionary["last_login"] as? String
        lastName = dictionary["last_name"] as? String
        latitude = dictionary["latitude"] as? String
        lognitude = dictionary["lognitude"] as? String
        mangoPayId = dictionary["mango_pay_id"] as? String
        mobileNumber = dictionary["mobile_number"] as? String
        otp = dictionary["otp"] as? String
        otpDatetime = dictionary["otp_datetime"] as? String
        password = dictionary["password"] as? String
        permanentLatitude = dictionary["permanent_latitude"] as? String
        permanentLognitude = dictionary["permanent_lognitude"] as? String
        promoCode = dictionary["promo_code"] as? String
        rating = dictionary["rating"] as? String ?? String(dictionary["rating"] as? Int ?? 0)
        review = dictionary["review"] as? Int
        role = dictionary["role"] as? String
        salt = dictionary["salt"] as? String
        status = dictionary["status"] as? String
        userImg = dictionary["user_img"] as? String
        zipCode = dictionary["zip_code"] as? String
        ratingList = [ModelProfileRatingList]()
        if let ratingListArray = dictionary["rating_list"] as? [[String:Any]]{
            for dic in ratingListArray{
                let value = ModelProfileRatingList(fromDictionary: dic)
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
        if certificateType != nil{
            dictionary["certificate_type"] = certificateType
        }
        if city != nil{
            dictionary["city"] = city
        }
        if companyName != nil{
            dictionary["company_name"] = companyName
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if cvrNumber != nil{
            dictionary["cvr_number"] = cvrNumber
        }
        if deviceToken != nil{
            dictionary["device_token"] = deviceToken
        }
        if deviceType != nil{
            dictionary["device_type"] = deviceType
        }
        if dob != nil{
            dictionary["dob"] = dob
        }
        if email != nil{
            dictionary["email"] = email
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if gender != nil{
            dictionary["gender"] = gender
        }
        if id != nil{
            dictionary["id"] = id
        }
        if industryCode != nil{
            dictionary["industry_code"] = industryCode
        }
        if lastLogin != nil{
            dictionary["last_login"] = lastLogin
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if latitude != nil{
            dictionary["latitude"] = latitude
        }
        if lognitude != nil{
            dictionary["lognitude"] = lognitude
        }
        if mangoPayId != nil{
            dictionary["mango_pay_id"] = mangoPayId
        }
        if mobileNumber != nil{
            dictionary["mobile_number"] = mobileNumber
        }
        if otp != nil{
            dictionary["otp"] = otp
        }
        if otpDatetime != nil{
            dictionary["otp_datetime"] = otpDatetime
        }
        if password != nil{
            dictionary["password"] = password
        }
        if permanentLatitude != nil{
            dictionary["permanent_latitude"] = permanentLatitude
        }
        if permanentLognitude != nil{
            dictionary["permanent_lognitude"] = permanentLognitude
        }
        if promoCode != nil{
            dictionary["promo_code"] = promoCode
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
        if salt != nil{
            dictionary["salt"] = salt
        }
        if status != nil{
            dictionary["status"] = status
        }
        if userImg != nil{
            dictionary["user_img"] = userImg
        }
        if zipCode != nil{
            dictionary["zip_code"] = zipCode
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
        certificateType = aDecoder.decodeObject(forKey: "certificate_type") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        companyName = aDecoder.decodeObject(forKey: "company_name") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        cvrNumber = aDecoder.decodeObject(forKey: "cvr_number") as? String
        deviceToken = aDecoder.decodeObject(forKey: "device_token") as? String
        deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
        dob = aDecoder.decodeObject(forKey: "dob") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        industryCode = aDecoder.decodeObject(forKey: "industry_code") as? String
        lastLogin = aDecoder.decodeObject(forKey: "last_login") as? String
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        lognitude = aDecoder.decodeObject(forKey: "lognitude") as? String
        mangoPayId = aDecoder.decodeObject(forKey: "mango_pay_id") as? String
        mobileNumber = aDecoder.decodeObject(forKey: "mobile_number") as? String
        otp = aDecoder.decodeObject(forKey: "otp") as? String
        otpDatetime = aDecoder.decodeObject(forKey: "otp_datetime") as? String
        password = aDecoder.decodeObject(forKey: "password") as? String
        permanentLatitude = aDecoder.decodeObject(forKey: "permanent_latitude") as? String
        permanentLognitude = aDecoder.decodeObject(forKey: "permanent_lognitude") as? String
        promoCode = aDecoder.decodeObject(forKey: "promo_code") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? String
        ratingList = aDecoder.decodeObject(forKey: "rating_list") as? [ModelProfileRatingList]
        review = aDecoder.decodeObject(forKey: "review") as? Int
        role = aDecoder.decodeObject(forKey: "role") as? String
        salt = aDecoder.decodeObject(forKey: "salt") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        userImg = aDecoder.decodeObject(forKey: "user_img") as? String
        zipCode = aDecoder.decodeObject(forKey: "zip_code") as? String
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
        if certificateType != nil{
            aCoder.encode(certificateType, forKey: "certificate_type")
        }
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if companyName != nil{
            aCoder.encode(companyName, forKey: "company_name")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if cvrNumber != nil{
            aCoder.encode(cvrNumber, forKey: "cvr_number")
        }
        if deviceToken != nil{
            aCoder.encode(deviceToken, forKey: "device_token")
        }
        if deviceType != nil{
            aCoder.encode(deviceType, forKey: "device_type")
        }
        if dob != nil{
            aCoder.encode(dob, forKey: "dob")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if industryCode != nil{
            aCoder.encode(industryCode, forKey: "industry_code")
        }
        if lastLogin != nil{
            aCoder.encode(lastLogin, forKey: "last_login")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        if lognitude != nil{
            aCoder.encode(lognitude, forKey: "lognitude")
        }
        if mangoPayId != nil{
            aCoder.encode(mangoPayId, forKey: "mango_pay_id")
        }
        if mobileNumber != nil{
            aCoder.encode(mobileNumber, forKey: "mobile_number")
        }
        if otp != nil{
            aCoder.encode(otp, forKey: "otp")
        }
        if otpDatetime != nil{
            aCoder.encode(otpDatetime, forKey: "otp_datetime")
        }
        if password != nil{
            aCoder.encode(password, forKey: "password")
        }
        if permanentLatitude != nil{
            aCoder.encode(permanentLatitude, forKey: "permanent_latitude")
        }
        if permanentLognitude != nil{
            aCoder.encode(permanentLognitude, forKey: "permanent_lognitude")
        }
        if promoCode != nil{
            aCoder.encode(promoCode, forKey: "promo_code")
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
        if salt != nil{
            aCoder.encode(salt, forKey: "salt")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if userImg != nil{
            aCoder.encode(userImg, forKey: "user_img")
        }
        if zipCode != nil{
            aCoder.encode(zipCode, forKey: "zip_code")
        }
    }
}
class ModelProfileRatingList : NSObject, NSCoding{

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
