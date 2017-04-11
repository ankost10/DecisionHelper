//
//  ViewController.swift
//  DecisionHelper
//
//  Created by Andrei on 2017-02-27.
//  Copyright © 2017 Andrei. All rights reserved.
//

import UIKit

class QuestionsViewController: UITableViewController, ShowQuestionViewControllerDelegate,UINavigationControllerDelegate {
    
    // get DataModel
  var dataModel: DataModel!
    private var addingQuestion = false
    private var questionToEditIndexPatch : IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        // edit button on the left
        navigationItem.rightBarButtonItem = editButtonItem
        tableView.allowsSelectionDuringEditing = true
       navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:self.view.tintColor]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedQuestion
        if index >= 0 && index < dataModel.questions.count {
 //           let question = dataModel.questions[index]
//            performSegue(withIdentifier: "ShowQuestion", sender: question)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        // if this is the editing mode, add one more row
        let adjustment = isEditing ? 1 : 0
        return dataModel.questions.count + adjustment
        
    }
    //Fill in rows with questions    
    override func tableView(_ tableView: UITableView,
                                cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionListCell", for: indexPath)
    // Fill in last virtual cell with " Add Question"
        if indexPath.row >= dataModel.questions.count && isEditing {
            cell.textLabel?.text = "Add Question"
            cell.detailTextLabel?.text = nil
        } else {
            let question = dataModel.questions[indexPath.row]
            cell.textLabel?.text = question.title
            let score = question.countScore()
            var detailTextLabel : String = "Answer is :"
            var detailTextColor : UIColor = .red
            switch score {
            case -100000000 ..< -1000 : detailTextLabel += "No, No way!!!!"
            case -1000 ..< 0 :detailTextLabel += "No"
            case 0 ..< 1000 :detailTextLabel += "Yes"
                            detailTextColor = view.tintColor
            default:
                detailTextLabel += "Yes, for sure"
                detailTextColor = view.tintColor
            }
            
            cell.detailTextLabel?.text = detailTextLabel
            cell.detailTextLabel?.textColor = detailTextColor
        }
            return cell
    }
    
    override func tableView(_ tableView: UITableView,
                   willBeginEditingRowAt indexPath: IndexPath){
    }
    
    
    // Add one extra cell to questions list in the editing mode
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        if editing {
            tableView.beginUpdates()
            let indexPath = IndexPath(row: dataModel.questions.count, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            tableView.setEditing(true, animated: true)
        } else {
            tableView.beginUpdates()
            let indexPath = IndexPath(row: dataModel.questions.count, section: 0)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            tableView.setEditing(false, animated: true)
            
        }
        
    }
    // add + button in the editing mode for the last row
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row >= dataModel.questions.count {
            return .insert}
        return .delete
    }
    
//    override func
    
    // Send Question to ShowQuestionViewController Screen through ShowQuestion segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ShowQuestion" || segue.identifier == "AddQuestion" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ShowQuestionViewController
            controller.delegate = self
            if isEditing || segue.identifier == "AddQuestion" { //Add Question Mode
                addingQuestion = true // set addingQuestion
                let newQuestionToEdit = Question (title: "Type your question here")
                controller.questionToEdit = newQuestionToEdit
            } else {// Editing mode
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                questionToEditIndexPatch = indexPath
                controller.questionToEdit = dataModel.questions[indexPath.row]
                } // if let
            } //Editing mode
        }
    }
    //handle Save button
    func ShowQuestionViewControllerSave(_ controller: ShowQuestionViewController,
                                        didFinishAdding question: Question) {
//        dataModel.indexOfSelectedQuestion = -1
        if addingQuestion {
            dataModel.questions.append(question)
                addingQuestion = false
        } else {
        dataModel.questions[(questionToEditIndexPatch?.row)!] = question
            }
        dismiss(animated: true, completion: nil)
      tableView.reloadData()
    }

    
    //Implement Delete button
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataModel.questions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with:.automatic)
        } // else if editingStyle == .insert {
            // Hadle Add question here
     //   }
    }

    // in the editing mode, user dont able to select any question cell
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if isEditing && indexPath.row < dataModel.questions.count {
            return nil
        }
        return indexPath
    }
 

    // except Add  Question cell
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing && indexPath.row >= dataModel.questions.count {
            dataModel.indexOfSelectedQuestion = indexPath.row
            self.tableView(tableView, commit: .insert, forRowAt: indexPath as IndexPath)
        }
    }
 
    
    
   // Implement Moving rows no need for CanMoveAtIndexPath, as all questions are movable
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.row != sourceIndexPath.row {
                swap(&dataModel.questions[destinationIndexPath.row], &dataModel.questions[sourceIndexPath.row])
            }
    }
 

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Was the back button tapped?
        if viewController === self {
            dataModel.indexOfSelectedQuestion = -1
        }

    }
}
