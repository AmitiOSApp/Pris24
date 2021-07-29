
import Foundation


class ModelSubCategory : NSObject, NSCoding{

    var message : String!
    var responseCode : Int!
    var subcategoryData : [ModelSubcategoryDatum]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        message = dictionary["message"] as? String
        responseCode = dictionary["responseCode"] as? Int
        subcategoryData = [ModelSubcategoryDatum]()
        if let subcategoryDataArray = dictionary["subcategory_data"] as? [[String:Any]]{
            for dic in subcategoryDataArray{
                let value = ModelSubcategoryDatum(fromDictionary: dic)
                subcategoryData.append(value)
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
        if subcategoryData != nil{
            var dictionaryElements = [[String:Any]]()
            for subcategoryDataElement in subcategoryData {
                dictionaryElements.append(subcategoryDataElement.toDictionary())
            }
            dictionary["subcategoryData"] = dictionaryElements
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
        subcategoryData = aDecoder.decodeObject(forKey: "subcategory_data") as? [ModelSubcategoryDatum]
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
        if subcategoryData != nil{
            aCoder.encode(subcategoryData, forKey: "subcategory_data")
        }
    }
}

class ModelSubcategoryDatum : NSObject, NSCoding{

    var categoryId : String!
    var createdAt : String!
    var id : String!
    var propertyName : [ModelPropertyName]!
    var status : String!
    var subcategoryImage : String!
    var subcategoryName : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        categoryId = dictionary["category_id"] as? String
        createdAt = dictionary["created_at"] as? String
        id = dictionary["id"] as? String
        status = dictionary["status"] as? String
        subcategoryImage = dictionary["subcategory_image"] as? String
        subcategoryName = dictionary["subcategory_name"] as? String
        propertyName = [ModelPropertyName]()
        if let propertyNameArray = dictionary["property_name"] as? [[String:Any]]{
            for dic in propertyNameArray{
                let value = ModelPropertyName(fromDictionary: dic)
                propertyName.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if categoryId != nil{
            dictionary["category_id"] = categoryId
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if status != nil{
            dictionary["status"] = status
        }
        if subcategoryImage != nil{
            dictionary["subcategory_image"] = subcategoryImage
        }
        if subcategoryName != nil{
            dictionary["subcategory_name"] = subcategoryName
        }
        if propertyName != nil{
            var dictionaryElements = [[String:Any]]()
            for propertyNameElement in propertyName {
                dictionaryElements.append(propertyNameElement.toDictionary())
            }
            dictionary["propertyName"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoryId = aDecoder.decodeObject(forKey: "category_id") as? String
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        propertyName = aDecoder.decodeObject(forKey: "property_name") as? [ModelPropertyName]
        status = aDecoder.decodeObject(forKey: "status") as? String
        subcategoryImage = aDecoder.decodeObject(forKey: "subcategory_image") as? String
        subcategoryName = aDecoder.decodeObject(forKey: "subcategory_name") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: "category_id")
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
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if subcategoryImage != nil{
            aCoder.encode(subcategoryImage, forKey: "subcategory_image")
        }
        if subcategoryName != nil{
            aCoder.encode(subcategoryName, forKey: "subcategory_name")
        }
    }
}
class ModelPropertyName : NSObject, NSCoding{

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
