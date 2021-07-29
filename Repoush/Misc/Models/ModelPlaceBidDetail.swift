//
//  ModelPlaceBidDetail.swift
//  Repoush
//
//  Created by Apple on 27/10/20.
//  Copyright © 2020 Ravi Sendhav. All rights reserved.
//

import Foundation
class ModelPlaceBidDetail : NSObject, NSCoding{

    var lastBidAmount : String!
    var message : String!
    var offerPrice : String!
    var responseCode : Int!
    var timeLeft : String!
    var timeLeftInSecond : Int!
    var totalBid : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        lastBidAmount = dictionary["last_bid_amount"] as? String
        message = dictionary["message"] as? String
        offerPrice = dictionary["offer_price"] as? String
        responseCode = dictionary["responseCode"] as? Int
        timeLeft = dictionary["time_left"] as? String
        timeLeftInSecond = dictionary["time_left_in_second"] as? Int
        totalBid = dictionary["total_bid"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if lastBidAmount != nil{
            dictionary["last_bid_amount"] = lastBidAmount
        }
        if message != nil{
            dictionary["message"] = message
        }
        if offerPrice != nil{
            dictionary["offer_price"] = offerPrice
        }
        if responseCode != nil{
            dictionary["responseCode"] = responseCode
        }
        if timeLeft != nil{
            dictionary["time_left"] = timeLeft
        }
        if timeLeftInSecond != nil{
            dictionary["time_left_in_second"] = timeLeftInSecond
        }
        if totalBid != nil{
            dictionary["total_bid"] = totalBid
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        lastBidAmount = aDecoder.decodeObject(forKey: "last_bid_amount") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
        offerPrice = aDecoder.decodeObject(forKey: "offer_price") as? String
        responseCode = aDecoder.decodeObject(forKey: "responseCode") as? Int
        timeLeft = aDecoder.decodeObject(forKey: "time_left") as? String
        timeLeftInSecond = aDecoder.decodeObject(forKey: "time_left_in_second") as? Int
        totalBid = aDecoder.decodeObject(forKey: "total_bid") as? Int
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if lastBidAmount != nil{
            aCoder.encode(lastBidAmount, forKey: "last_bid_amount")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if offerPrice != nil{
            aCoder.encode(offerPrice, forKey: "offer_price")
        }
        if responseCode != nil{
            aCoder.encode(responseCode, forKey: "responseCode")
        }
        if timeLeft != nil{
            aCoder.encode(timeLeft, forKey: "time_left")
        }
        if timeLeftInSecond != nil{
            aCoder.encode(timeLeftInSecond, forKey: "time_left_in_second")
        }
        if totalBid != nil{
            aCoder.encode(totalBid, forKey: "total_bid")
        }
    }
}
