//
//  Question.swift
//  DecisionHelper
//
//  Created by Andrei on 2017-02-27.
//  Copyright © 2017 Andrei. All rights reserved.
//

//import Foundation
import UIKit

class Question: NSObject, NSCoding {
    var questionID : Int
    var title = ""
    var strengthsItems = [QuestionItem]()
    var weaknessesItems = [QuestionItem]()
    var opportunitiesItems = [QuestionItem]()
    var threatsItems = [QuestionItem]()

    

    
   init(title: String) {
        self.title = title
        questionID = DataModel.nextQuestionID()
        super.init()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "Title") as! String
        strengthsItems = aDecoder.decodeObject(forKey: "StrengthsItems") as! [QuestionItem]
        weaknessesItems = aDecoder.decodeObject(forKey: "WeaknessesItems") as! [QuestionItem]
        opportunitiesItems = aDecoder.decodeObject(forKey: "OpportunitiesItems") as! [QuestionItem]
        threatsItems = aDecoder.decodeObject(forKey: "ThreatsItems") as! [QuestionItem]
        questionID = aDecoder.decodeInteger(forKey: "QuestionID")
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "Title")
        aCoder.encode(strengthsItems, forKey: "StrengthsItems")
        aCoder.encode(weaknessesItems, forKey: "WeaknessesItems")
        aCoder.encode(opportunitiesItems, forKey: "OpportunitiesItems")
        aCoder.encode(threatsItems, forKey: "ThreatsItems")
        aCoder.encode(questionID, forKey: "QuestionID")
    }
    
    func countScore() -> Int {
        var count = 0
        for item in strengthsItems {
            count += item.getPoints()
        }
        for item in weaknessesItems {
            count -= item.getPoints()
        }
        for item in opportunitiesItems {
            count += item.getPoints()
        }
        for item in threatsItems {
            count -= item.getPoints()
        }
        return count
    }
}
