//
//  ArticalDataModel.swift
//  FlupperTest
//
//  Created by Sunil Kumar on 13/08/20.
//  Copyright © 2020 UttamTech. All rights reserved.
//

import Foundation
 
public class ArticalDataModel {
    
    //MARK:- Variables
    public var id : String?
    public var name : String?
    public var author : String?
    public var title : String?
    public var descriptions : String?
    public var urlToImage : String?

    public class func modelsFromDictionaryArray(array:NSMutableArray) -> [ArticalDataModel]
    {
        var models:[ArticalDataModel] = []
        for item in array
        {
            models.append(ArticalDataModel(dictionary: item as! NSMutableDictionary)!)
        }
        return models
    }
    
    init() { }

    required public init?(dictionary: NSMutableDictionary) {
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        author = dictionary["author"] as? String
        title = dictionary["title"] as? String
        descriptions = dictionary["descriptions"] as? String
        urlToImage = dictionary["urlToImage"] as? String
    }

    //MARK:- For Print data
    public func dictionaryRepresentation() -> NSMutableDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(self.id, forKey: "id")
        dictionary.setValue(self.name, forKey: "name")
        dictionary.setValue(self.author, forKey: "author")
        dictionary.setValue(self.title, forKey: "title")
        dictionary.setValue(self.descriptions, forKey: "descriptions")
        dictionary.setValue(self.urlToImage, forKey: "urlToImage")
        return dictionary
    }

}
