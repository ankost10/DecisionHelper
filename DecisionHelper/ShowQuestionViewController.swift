//
//  ShowQuestionViewController.swift
//  DecisionHelper
//
//  Created by Andrei on 2017-03-05.
//  Copyright © 2017 Andrei. All rights reserved.
//s

import UIKit

protocol ShowQuestionViewControllerDelegate : class {
   func ShowQuestionViewControllerSave(_ controller: ShowQuestionViewController,
                                  didFinishAdding item: Question)
}


class ShowQuestionViewController: UIViewController, UITextFieldDelegate, ShowArgumentViewControllerDelegate {
    
    weak var delegate: ShowQuestionViewControllerDelegate?
    var questionToEdit: Question?
    var isPros = true

    private var questionItemToEditIndexPatch : IndexPath?
    private var questionToEditItemType : QuestionItem.ItemType = .strengths
    private var addingQuestionItem = false
    
    @IBOutlet weak var questionTitle: UITextField!
    @IBOutlet weak var tableView: UITableView!
  
    @IBAction func done(_ sender: Any) {
        questionToEdit?.title = questionTitle.text!
        delegate?.ShowQuestionViewControllerSave(self, didFinishAdding: questionToEdit!)
    }

    @IBAction func switchPros(_ sender: Any) {
               isPros = !isPros
        tableView.reloadData()
    }
    
    // User has changed title - hit done button on the keyboard
    @IBAction func titleHasChanged(_ sender: Any) {
        tableView.reloadData()
    }
 
   
    override func viewWillAppear(_ animated: Bool) {
        automaticallyAdjustsScrollViewInsets = false
         tableView.allowsSelectionDuringEditing = true
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        navigationItem.rightBarButtonItem = editButtonItem
        tableView.allowsSelectionDuringEditing = true
      
        if let question = questionToEdit {
            questionTitle.text = "\(question.title)"

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getStatus (section : Int) -> QuestionItem.ItemType{
        if isPros && section == 0  { return .strengths}
        if isPros && section == 1  { return .opportunities}
        if !isPros && section == 0  { return .weaknesses}
        return .threats
    }
    
    func getNumberOfRows (inSection : Int) -> Int {
        
        switch getStatus (section: inSection ){
        case .strengths : return(questionToEdit?.strengthsItems.count)!
        case .opportunities : return(questionToEdit?.opportunitiesItems.count)!
        case .weaknesses : return (questionToEdit?.weaknessesItems.count)!
        default : return (questionToEdit?.threatsItems.count)!
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditItem" {
            let navigationController = segue.destination  as! UINavigationController
            let controller = navigationController.topViewController as! ShowArgumentViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                  // save indexPath itemType. We use these item is returned
                questionItemToEditIndexPatch = indexPath
                
                if isEditing {// this is Add Argument table list item pressed
                    let newQuestionToEdit = QuestionItem(text: "Type your argument here", importance: 10, probability: 1, withType: getStatus(section: indexPath.section))
                    controller.itemToEdit = newQuestionToEdit
                    addingQuestionItem = true
                } else {
                
                switch getStatus(section: indexPath.section) {
                case .strengths : controller.itemToEdit = (questionToEdit?.strengthsItems[indexPath.row])!
                case .opportunities : controller.itemToEdit = (questionToEdit?.opportunitiesItems[indexPath.row])!
                case .weaknesses : controller.itemToEdit = (questionToEdit?.weaknessesItems[indexPath.row])!
                case .threats: controller.itemToEdit = (questionToEdit?.threatsItems[indexPath.row])!
                    }
                }
                questionToEditItemType = (controller.itemToEdit?.itemType)!
            }
        }
    }
    
    
    // Implement Show Item Table view protocol
    
    func ShowArgumentViewControllerDidCancel(_ controller: ShowArgumentViewController) {
          dismiss(animated: true, completion: nil)
        addingQuestionItem = false
    }
    
    func ShowArgumentViewController(_ controller: ShowArgumentViewController, didFinishAdding item: QuestionItem) {
    if let questionItem = controller.itemToEdit {
        
        if addingQuestionItem { // this is a new question item to be saved. don't do anything else
            addingQuestionItem = false // reset addingQuestionItem
            switch questionItem.itemType {
            case .strengths : questionToEdit?.strengthsItems.append(questionItem)
            case .weaknesses : questionToEdit?.weaknessesItems.append(questionItem)
            case .opportunities : questionToEdit?.opportunitiesItems.append(questionItem)
            case .threats: questionToEdit?.threatsItems.append(questionItem)
            } //switch append

            
        } else {
    
        // check to see if it is the same Item type, just update it
        if controller.itemToEdit?.itemType == questionToEditItemType {
            switch questionItem.itemType {
            case .strengths : questionToEdit?.strengthsItems[(questionItemToEditIndexPatch?.row)!] = questionItem
            case .weaknesses : questionToEdit?.weaknessesItems [(questionItemToEditIndexPatch?.row)!] = questionItem
            case .opportunities : questionToEdit?.opportunitiesItems [(questionItemToEditIndexPatch?.row)!] = questionItem
            case .threats: questionToEdit?.threatsItems [(questionItemToEditIndexPatch?.row)!] = questionItem
                } //switch
            }  else {// check Item type
        // if not the same item type. remove the old one and add new one to the proper table
            switch questionItem.itemType {
                case .strengths : questionToEdit?.strengthsItems.append(questionItem)
                case .weaknesses : questionToEdit?.weaknessesItems.append(questionItem)
                case .opportunities : questionToEdit?.opportunitiesItems.append(questionItem)
                case .threats: questionToEdit?.threatsItems.append(questionItem)
                } //switch append
           switch questionToEditItemType {
            case .strengths : questionToEdit?.strengthsItems.remove(at: (questionItemToEditIndexPatch?.row)!)
            case .weaknesses : questionToEdit?.weaknessesItems.remove(at: (questionItemToEditIndexPatch?.row)!)
            case .opportunities : questionToEdit?.opportunitiesItems.remove(at: (questionItemToEditIndexPatch?.row)!)
            case .threats: questionToEdit?.threatsItems.remove(at: (questionItemToEditIndexPatch?.row)!)
                } //switch remove
            } //else check Item Type
            }// else addingQuestionItem
        } // if let
        dismiss(animated: true, completion: nil)
    
    }

}

extension ShowQuestionViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let adjustment = isEditing ? 1 : 0
        return getNumberOfRows(inSection: section) + adjustment
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch getStatus(section: section) {
        case .strengths : return "Personal factors"
        case .opportunities : return "External factors"
        case .weaknesses : return "Personal factors"
        case .threats: return "External factors"
        }
    }
  
  
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = self.view.tintColor
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            tableView.beginUpdates()
            if isPros {
            var indexPath = IndexPath(row: (questionToEdit?.strengthsItems.count)!, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            indexPath = IndexPath(row: (questionToEdit?.opportunitiesItems.count)!, section: 1)
            tableView.insertRows(at: [indexPath], with: .automatic)
            } else {
            var indexPath = IndexPath(row: (questionToEdit?.weaknessesItems.count)!, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            indexPath = IndexPath(row: (questionToEdit?.threatsItems.count)!, section: 1)
            tableView.insertRows(at: [indexPath], with: .automatic)
                }
            tableView.endUpdates()
            tableView.setEditing(true, animated: true)
            
       } else {
            tableView.beginUpdates()
            if isPros {
                var indexPath = IndexPath(row: (questionToEdit?.strengthsItems.count)!, section: 0)
                  tableView.deleteRows(at: [indexPath], with: .automatic)
                indexPath = IndexPath(row: (questionToEdit?.opportunitiesItems.count)!, section: 1)
                  tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                var indexPath = IndexPath(row: (questionToEdit?.weaknessesItems.count)!, section: 0)
                  tableView.deleteRows(at: [indexPath], with: .automatic)
                indexPath = IndexPath(row: (questionToEdit?.threatsItems.count)!, section: 1)
                  tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            tableView.endUpdates()
            tableView.setEditing(false, animated: true)
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionItemCell", for: indexPath)

        if indexPath.row >= getNumberOfRows(inSection: indexPath.section) && isEditing {
            cell.textLabel?.text = "Add Argument "
            cell.detailTextLabel?.text = nil
        } else {
            var questionItem = questionToEdit?.strengthsItems[0]
            switch getStatus(section: indexPath.section) {
            case .strengths :  questionItem = questionToEdit?.strengthsItems[indexPath.row]
            case .opportunities :  questionItem = questionToEdit?.opportunitiesItems[indexPath.row]
            case .weaknesses :  questionItem = questionToEdit?.weaknessesItems[indexPath.row]
            case .threats:  questionItem = questionToEdit?.threatsItems[indexPath.row]
                } //switch
            cell.textLabel?.text = questionItem?.text
            
            
            cell.detailTextLabel?.text = getArgumentInfo(importance: (questionItem?.importance)!, probability: (questionItem?.probability)!, cons: questionItem?.itemType == .weaknesses || questionItem?.itemType == .threats)
            cell.detailTextLabel?.textColor = UIColor.gray
        }
        return cell
    
    }
    func getArgumentInfo (importance : Double, probability : Double, cons :Bool) ->String {
        
        var infoText :String = ""
        if importance < 2.5 { return " Does not really matter"}
        if probability < 0.25 {return "Should never happen"}
        if !cons {
            switch importance {
                case 0..<5 : infoText = "Slightly important"
                case 0..<7.5 : infoText = "It is important"
                case 0..<10 : infoText = "Very important"
            default : infoText = "Extremely important"
            }
        } else {
            switch importance {
                case 0..<5 : infoText = "I'll be upset "
                case 0..<7.5 : infoText = "Could be a concern"
                case 0..<10 : infoText = "Could be a trouble"
            default : infoText = "Huge hassle"
            }
        }
            switch probability {
                case 0..<0.5: infoText += " but chances are low"
                case 0..<0.75: infoText += " with 50/50 chances"
                case 0..<1.0 : infoText += " and mostlikely to happen"
            default: infoText += " and will happen for sure"
            }
        return infoText

    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
                if indexPath.row >= getNumberOfRows(inSection: indexPath.section) { return .insert}
        return .delete
    }
    
    
    
    //Implement swipe and Delete button
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch getStatus(section: indexPath.section) {
            case .strengths : questionToEdit?.strengthsItems.remove(at: indexPath.row)
            case .opportunities : questionToEdit?.opportunitiesItems.remove(at: indexPath.row)
            case .weaknesses : questionToEdit?.weaknessesItems.remove(at: indexPath.row)
            case .threats: questionToEdit?.threatsItems.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with:.automatic)
        } else if editingStyle == .insert {
//      Handle Add question Item here
       }
    }

    // in the editing mode, user dont able to select any question cell

    func tableView(_ tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.row < getNumberOfRows(inSection: indexPath.section) && isEditing {
            return nil}
        return indexPath
    }
    // except Add  Question cell
    
     func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if indexPath.row >= getNumberOfRows(inSection: indexPath.section) && isEditing {
            self.tableView(tableView, commit: .insert, forRowAt: indexPath as IndexPath)
        }
        
    }
    // Implelemntation of Moving rows
    
    // Add item cell should not be movable
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row >= getNumberOfRows(inSection: indexPath.section) { return false}
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
// get question item from source and remove it
        let sourceQItemStatus = getStatus(section: sourceIndexPath.section)
        var sourceQuestionItem : QuestionItem
        switch sourceQItemStatus {
        case .strengths : sourceQuestionItem = (questionToEdit?.strengthsItems[sourceIndexPath.row])!
            questionToEdit?.strengthsItems.remove(at: sourceIndexPath.row)
        case .opportunities :  sourceQuestionItem = (questionToEdit?.opportunitiesItems[sourceIndexPath.row])!
            questionToEdit?.opportunitiesItems.remove(at: sourceIndexPath.row)
        case .weaknesses :  sourceQuestionItem = (questionToEdit?.weaknessesItems[sourceIndexPath.row])!
        questionToEdit?.weaknessesItems.remove(at: sourceIndexPath.row)
        case .threats:  sourceQuestionItem = (questionToEdit?.threatsItems[sourceIndexPath.row])!
        questionToEdit?.threatsItems.remove(at: sourceIndexPath.row)
        } //switch
        
// insert source question item 
        
        let destinationQItemStatus = getStatus(section: destinationIndexPath.section)
        switch destinationQItemStatus {
        case .strengths :questionToEdit?.strengthsItems.insert(sourceQuestionItem, at: destinationIndexPath.row)
        case .opportunities :  questionToEdit?.opportunitiesItems.insert(sourceQuestionItem, at: destinationIndexPath.row)
        case .weaknesses : questionToEdit?.weaknessesItems.insert(sourceQuestionItem, at: destinationIndexPath.row)
        case .threats: questionToEdit?.threatsItems.insert(sourceQuestionItem, at: destinationIndexPath.row)
        } //switch
    }
        
       // prevent from moving cell below Add item cell

         func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
            let maxRowNumber = getNumberOfRows(inSection: proposedDestinationIndexPath.section)
            if proposedDestinationIndexPath.row >=  maxRowNumber {
                return NSIndexPath(row: maxRowNumber-1, section: proposedDestinationIndexPath.section)
            }
            return proposedDestinationIndexPath
            
        }

    
}
