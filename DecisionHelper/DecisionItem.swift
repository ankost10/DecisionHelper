//
//  DecisionItem.swift
//  DecisionHelper
//
//  Created by Andrei on 2017-02-27.
//  Copyright © 2017 Andrei. All rights reserved.
//

import Foundation

class QuestionItem: NSObject, NSCoding {
    enum  ItemType :Int {case strengths, weaknesses, opportunities,threats }
    var text = ""
    var importance = 10.0
    var probability = 1.0
    var itemType : ItemType = .strengths
    var itemID : Int = 0
    

    
    convenience override init() {
        self.init(text : "Test", importance : 10.0, probability : 1.0, withType :.strengths )
    }
    
    init(text : String, importance : Double, probability : Double, withType : ItemType ) {
        self.text = text
        self.importance = importance
        self.probability = probability
        itemType = withType
        itemID = DataModel.nextQuestionItemID()
        super.init()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        importance = aDecoder.decodeDouble(forKey: "Importance")
        probability = aDecoder.decodeDouble(forKey: "Probability")
        itemType = ItemType(rawValue: aDecoder.decodeInteger(forKey: "ItemType"))!
       itemID = aDecoder.decodeInteger(forKey: "ItemID")
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(importance, forKey: "Importance")
        aCoder.encode(probability, forKey: "Probability")
        aCoder.encode(itemType.rawValue, forKey: "ItemType")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    
    
    func getPoints() -> Int {
        return Int (importance * probability*100)
    
    }

}
