//
//  DataModel.swift
//  DecisionHelper
//
//  Created by Andrei on 2017-02-27.
//  Copyright © 2017 Andrei. All rights reserved.
//

import Foundation

class DataModel {
    var questions = [Question]()
    var indexOfSelectedQuestion: Int {
        get {
            return UserDefaults.standard.integer(forKey: "QuestionID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "QuestionID")
        }
    }
    

    init() {
        loadQuestions()
        registerDefaults()
        handleFirstTime()
        
    }
    
    // Get the next ID for the Question Item. Each time it gets incremented and stored in defaults
    class func nextQuestionItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "QuestionItemID")
        userDefaults.set(itemID + 1, forKey: "QuestionItemID")
        userDefaults.synchronize()
        return itemID
    }
    
    class func nextQuestionID() -> Int {
        let userDefaults = UserDefaults.standard
        let questionID = userDefaults.integer(forKey: "QuestionID")
        userDefaults.set(questionID + 1, forKey: "QuestionID")
        userDefaults.synchronize()
        return questionID
    }
    
    
    // register defaults. If index is -1 then user was looking t the main screen
private    func registerDefaults() {
        let dictionary: [String: Any] = [ "QuestionIndex": -1, "FirstTime": true, "QuestionItemID": 0, "QuestionID": 0 ]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    
    // What to do when app starts for the 1st time
private    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        if firstTime {
            // Load Initial Questions here
            if !setFirstQuestions () {
                print("Error First Questions Initialization")
            }
            saveQuestions ()
        indexOfSelectedQuestion = 0
        userDefaults.set(false, forKey: "FirstTime")
        userDefaults.synchronize()
        }
    }
    

    func addQuestionItem (withID questionID : Int, questionItem : QuestionItem) -> Bool {
        if let question = questions.filter({$0.questionID == questionID}).first {
            switch questionItem.itemType {
            case .strengths : question.strengthsItems.append(questionItem)
            case .weaknesses : question.weaknessesItems.append(questionItem)
            case .opportunities : question.opportunitiesItems.append(questionItem)
            case .threats: question.threatsItems.append(questionItem)
            }
        } else {
            return false
        }
        return true
    }
    
    
       // Save data in the plst file
    func documentsDirectory () -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("Path = \(path)")
        return path [0]
    }
    
    func dataFilePath () -> URL {
        return documentsDirectory().appendingPathComponent("DecisionHelper.plist")
    }
    
    func saveQuestions() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(questions, forKey: "Questions")
        archiver.finishEncoding()
        print("save to file \(dataFilePath)")
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadQuestions() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            questions = unarchiver.decodeObject(forKey: "Questions") as! [Question]
            unarchiver.finishDecoding()
       }
        
    }
    
private    func setFirstQuestions () -> Bool{
        
        var question = Question(title: "Buy a new car instead of the used car")
        questions.append(question)
        var questionID = question.questionID
        
        var questionItem = QuestionItem(text: "It will lasts  for a long  time", importance: 10, probability: 0.70, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Warranty covers major repair", importance: 9, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Less service maintenance", importance: 9, probability: 0.7, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Less gas required", importance: 8, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My GF will think  that I am making a lot of money", importance: 3, probability: 0.7, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My friends will be jealous", importance: 2, probability: 0.5, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "its clean, shiny, brand new and smells good", importance: 1, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need more money", importance: 10, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need to arrange a car loan", importance: 9, probability: 0.7, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need to pass a credit check", importance: 3, probability: 0.7, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need to find saving in my budget", importance: 8, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need to get an extra income", importance: 3, probability: 0.5, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Insurance rate is getting higher", importance: 2, probability: 0.5, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need to buy some extra stuff : winter tires, floor mats and etc.", importance: 10, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Gas is getting more expensive, but I am going to use less gas", importance: 2, probability: 0.5, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Could wait for promotion and get a better deal", importance: 8, probability: 0.5, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I will produce less impact on environment", importance: 5, probability: 1.0, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "One of my friends could buy a better car", importance: 9, probability: 0.8, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Car maker could introduce a new model next year, and I will be driving an ìold carî", importance: 8, probability: 0.5, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Resale value is declining faster", importance: 5, probability: 1.0, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I could loose my job and have no money to pay for the car loan", importance: 10, probability: 0.1, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        
        question = Question(title: "Buy a iPhone instead of the Android phone")
        questions.append(question)
        questionID = question.questionID
        questionItem = QuestionItem(text: "It is easy to learn how to use", importance: 7, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need more money", importance: 10, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "iPhone has features that I need", importance: 9, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Android phone has features that I need", importance: 9, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Easy to search and buy new music", importance: 9, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Does not talk to my Android tablet", importance: 0, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "No hassles updating to a new software release", importance: 7, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need to wait longer before upgrading to the new model", importance: 8, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "No need to transfer my mail, contacts, pictures, music from current iPhone", importance: 10, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need to transfer my mail, contacts, pictures, music from current Android", importance: 0, probability: 1.0,  withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My GF will think that I am making a lot of money", importance: 4, probability: 0.7, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Phone is usually more fragile (more breakable)", importance: 7, probability: 0.3,  withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My friends will be jealous", importance: 3, probability: 0.5, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "All my friends have Andriod phones", importance: 2, probability: 0.5,  withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "its looks nice and I like these roundly squares", importance: 8, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I like Android phone design more", importance: 0, probability: 1.0,  withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Keeps good resale value", importance: 5, probability: 0.5, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My friends will think that I am not a computer guy", importance: 9, probability: 0.8, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Apple could introduce more iPhone specific features", importance: 8, probability: 0.3, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Apple could introduce a new model next year, and I will be using an ìold iPhone", importance: 8, probability: 0.5, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Reliable hardware and easy to repair", importance: 5, probability: 0.3, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Could be a problem with hardware that would hurt Apple reputation", importance: 5, probability: 1.0, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        
        
        question = Question(title:"Should I get a kitten?")
        questions.append(question)
        questionID = question.questionID
        questionItem = QuestionItem(text: "It's so cute!!!", importance: 10, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need more money", importance: 10, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I will not be alone anymore", importance: 10, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Have to clean after cat", importance: 9, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "It ís fun to look at it playing", importance: 9, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Litter smell", importance: 9, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "It's taking stress off", importance: 7, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need more time to take care about kitten", importance: 10, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "its fun to take care about it", importance: 6, probability:  10, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Must be a long term commitment", importance: 10, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My family will be happier", importance: 5, probability: 0.5, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "What would  you feel if Kitten got sick", importance: 9, probability: 1.0, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My kids will learn how to take care about", importance: 8, probability: 0.5, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "What would you feel if it got run over by the car or got lost", importance: 8, probability: 1.0,  withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My friends will be jealous", importance: 3, probability: 0.3, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "What if your family member is allergic to cats", importance: 10, probability: 0.1, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        
        
        question = Question(title: "Should I get a puppy?")
        questions.append(question)
        questionID = question.questionID
        questionItem = QuestionItem(text: "Its so cute!!!", importance: 10, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need more money", importance: 10, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I will not be alone anymore", importance: 10, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Have to clean after cat", importance: 9, probability: 1.0,  withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "It's fun to look at it playing", importance: 9, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Litter smell", importance: 9, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "It's taking stress off", importance: 7, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Need more time to take care about puppy", importance: 10, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "its fun to take care about it", importance: 6, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Must be a long term commitment", importance: 10, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My family will be happier", importance: 5, probability: 0.5, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "What would  you feel if puppy got sick", importance: 9, probability: 1.0, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My kids will learn how to take care about", importance: 8, probability: 0.5, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "What would I feel if it got run over by the car or got lost", importance: 8, probability: 1.0, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My friends will be jealous", importance: 3, probability: 0.3, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "What if your family member is allergic to dogs", importance: 10, probability: 0.1, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        
        question = Question(title: "Should I change a job?")
        questions.append(question)
        questionID = question.questionID
        questionItem = QuestionItem(text: "Making more money", importance: 7, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Loosing seniority level with current employer", importance: 10, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "More flexible schedule", importance: 9, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Losing my current friends at the job", importance: 9, probability: 0.5, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "More health benefits", importance: 9, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Have to learn new things", importance: 7, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "More friendly co workers", importance: 7, probability: 0.6, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Have to gain new experience", importance: 8, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "More vacation days", importance: 10, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Loosing number of vacation days", importance: 0, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Higher position level", importance: 4, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Loosing current position level", importance: 7, probability: 0.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Better known company brand", importance: 5, probability: 0.5, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "New company could change a location", importance: 9, probability: 0.8, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My friends will be jealous", importance: 8, probability: 0.3, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "My friends could find a better position", importance: 8, probability: 0, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "Company is growing", importance: 5, probability: 0.3, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "New company is downsizing", importance: 5, probability: 1.0, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        
        
        question = Question(title: "Should I dump my GF?")
        questions.append(question)
        questionID = question.questionID
        questionItem = QuestionItem(text: "I would feel free", importance: 7, probability: 1.0,  withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I will be missing her", importance: 10, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I could do more travelling", importance: 9, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "It will be boring without her", importance: 9, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I could spend more money on myself", importance: 9, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I would need to take care about food", importance: 0, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I could meet other girls", importance: 7, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I would need to clean my house on my own", importance: 8, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I could party with my friends", importance: 10, probability: 1.0, withType: .strengths)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I would have to search for someone new", importance: 0, probability: 1.0, withType: .weaknesses)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I could find a better GF", importance: 5, probability: 0.5, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I loose  financial support from her side", importance: 9, probability: 0.8, withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I could rent a smaller place", importance: 8, probability: 0.3, withType: .opportunities)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
        questionItem = QuestionItem(text: "I loose place to live and search for another one", importance: 8, probability: 0.5,withType: .threats)
        if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            
            
            question = Question(title: "Should I dump my BF?")
            questions.append(question)
            questionID = question.questionID
            questionItem = QuestionItem(text: "I would feel free", importance: 7, probability: 1.0, withType: .strengths)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "I will be missing him", importance: 10, probability: 1.0, withType: .weaknesses)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "I could do more travelling", importance: 9, probability: 1.0, withType: .strengths)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "It will be boring without him", importance: 9, probability: 1.0, withType: .weaknesses)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "I could spend more money on myself", importance: 9, probability: 1.0, withType: .strengths)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "I would need to take care about food", importance: 0, probability: 1.0,  withType: .weaknesses)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "I could meet other guys", importance: 7, probability: 1.0, withType: .strengths)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "I would need to clean my house on my own", importance: 8, probability: 1.0, withType: .weaknesses)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "I could party with my friends", importance: 10, probability: 1.0, withType: .strengths)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "I would have to search for someone new", importance: 0, probability: 1.0, withType: .weaknesses)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "I could find a better Boyfriend", importance: 5, probability: 0.5, withType: .opportunities)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "I loose  financial support from his side", importance: 9, probability: 0.8, withType: .threats)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "I could rent a smaller place", importance: 8, probability: 0.3, withType: .opportunities)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }
            questionItem = QuestionItem(text: "I loose place to live and search for another one", importance: 8, probability: 0.5, withType: .threats)
            if !addQuestionItem (withID: questionID, questionItem: questionItem) {return false }

        return true
    }
    
    
}
