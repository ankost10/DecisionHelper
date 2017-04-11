//
//  ShowArgumentViewController.swift
//  DecisionHelper
//
//  Created by Andrei on 2017-03-29.
//  Copyright © 2017 Andrei. All rights reserved.
//

import UIKit
import Foundation


protocol ShowArgumentViewControllerDelegate: class {
    func ShowArgumentViewControllerDidCancel(_ controller: ShowArgumentViewController)
    func ShowArgumentViewController(_ controller: ShowArgumentViewController, didFinishAdding item: QuestionItem)
}



class ShowArgumentViewController: UIViewController,

    UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: ShowArgumentViewControllerDelegate?
    var itemToEdit : QuestionItem?
    private var isPros = true
    private var isPersonal = true
    private var importancePickerData = ["Highest","Significant","Average","Almost nothing","Don't care"]
    private var severityPickerData = ["Huge hassle","Big Trouble","Concern","Upset","Don't care"]
    private var probabilityPickerData = ["Sure thing","Most likely","50/50","Least likely","Never"]
    
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var isProsButton: UISegmentedControl!
    @IBOutlet weak var importancePicker: UIPickerView!
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var itemEditText: UITextField!
    @IBOutlet weak var currentImportance: UITextField!
    @IBOutlet weak var factorButton: UISegmentedControl!
    @IBOutlet weak var probabilityPicker: UIPickerView!
    @IBOutlet weak var currentProbability: UITextField!
  
    
    @IBAction func switchPros(_ sender: Any) {
        isPros = isProsButton.selectedSegmentIndex == 0
        //Enable Done button only if text not empty
        doneBarButton.isEnabled = itemEditText.text != ""
        itemEditText.resignFirstResponder()
        if let row = convertToStringIndex (double: (itemToEdit?.importance)!*10) {
        if isPros {
            importanceLabel.text = "Select importance for you"
            currentImportance.text = importancePickerData [row]
        } else {
            importanceLabel.text = "Select severity for you"
            currentImportance.text = severityPickerData [row]
            }
        }
    }
    
    @IBAction func factorSwitch(_ sender: Any) {
        isPersonal = factorButton.selectedSegmentIndex == 0
        doneBarButton.isEnabled = itemEditText.text != ""
        itemEditText.resignFirstResponder()

    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.ShowArgumentViewControllerDidCancel(self)

    }
    
    @IBAction func done(_ sender: Any) {
        if isPros && isPersonal { itemToEdit?.itemType = .strengths}
        if isPros && !isPersonal { itemToEdit?.itemType = .opportunities}
        if !isPros && isPersonal { itemToEdit?.itemType = .weaknesses}
        if !isPros && !isPersonal { itemToEdit?.itemType = .threats}
        
        itemToEdit = QuestionItem (text : itemEditText.text!, importance : (itemToEdit?.importance)!, probability : (itemToEdit?.probability)!, withType : (itemToEdit?.itemType)! )
        delegate?.ShowArgumentViewController(self, didFinishAdding: itemToEdit!)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:self.view.tintColor]
        
        if itemToEdit?.itemType == .weaknesses || itemToEdit?.itemType == .threats {
            isProsButton.selectedSegmentIndex = 1
            isPros = false
        }
        if itemToEdit?.itemType == .opportunities || itemToEdit?.itemType == .threats {
            factorButton.selectedSegmentIndex = 1
            isPersonal = false
        }
        self.itemEditText.delegate = self
        itemEditText.text = itemToEdit?.text
        
    // Connect data to picker views
        //Importance picker
        self.importancePicker.delegate = self
        self.currentImportance.delegate = self
        self.importancePicker.dataSource = self
        if let row = convertToStringIndex (double: (itemToEdit?.importance)!*10) {
            importancePicker.selectRow(row, inComponent: 0, animated: false)
            if isPros {
                self.currentImportance.text = importancePickerData [row]
            } else {
                self.currentImportance.text = severityPickerData [row]
            }
            self.currentImportance.textColor = view.tintColor
        }
        self.importancePicker.isHidden = true
        
        //probability picker
        self.probabilityPicker.delegate = self
        self.currentProbability.delegate = self
        self.probabilityPicker.dataSource = self
        if let row = convertToStringIndex (double: (itemToEdit?.probability)!*100) {
            probabilityPicker.selectRow(row, inComponent: 0, animated: false)
            self.currentProbability.text = probabilityPickerData [row]
            self.currentProbability.textColor = view.tintColor
        }
        self.probabilityPicker.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Handle text field here
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == currentImportance {
            // User pressed Current Importance text, then show importance picker
            importancePicker.isHidden = false
            return false
        } else if textField == currentProbability {
            probabilityPicker.isHidden = false
            return false
        }
        return true
    }
      //Enable Done button only if changes were made
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    // When user press clear button, disable Done button
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }

    // Configure both Pickers
    
    // The number of columns of data for bothe pickers = 1
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data for both pickers = 5
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // compare pointers for the object pickerview
        if pickerView == probabilityPicker {
            return probabilityPickerData.count
        }
        return importancePickerData.count
    }
    
    // Fill in Pickers rows
 
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title = importancePickerData [row]
        if !isPros {
            title = severityPickerData [row]
        }
        if pickerView == probabilityPicker {
            title = probabilityPickerData [row]
        }
        let myTitle = NSAttributedString(string: title, attributes:
            //[NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,
            [NSForegroundColorAttributeName:view.tintColor])
        return myTitle
   }

    
    func convertToStringIndex (double: Double) -> Int? {
        switch double {
        case 0..<25 : return 4
        case 0..<50 : return 3
        case 0..<75 : return 2
        case 0..<100 : return 1
        default : return 0
        }
    }
    
    func convertRowToDouble (row: Int) -> Double?{
        switch row {
        case 0: return 100
        case 1: return 75
        case 2: return 50
        case 3: return 25
        default: return 0
        }
    }
    
    // update probability and importance
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        doneBarButton.isEnabled = itemEditText.text != ""
        itemEditText.resignFirstResponder()
        
        if pickerView == probabilityPicker {
            itemToEdit?.probability = convertRowToDouble (row: row)! / 100
            currentProbability.text = probabilityPickerData [row]
            // hide Probability picker
            probabilityPicker.isHidden = true
            
        } else {
            itemToEdit?.importance = convertRowToDouble(row: row)!/10
            if isPros {
                self.currentImportance.text = importancePickerData [row]
            } else {
                self.currentImportance.text = severityPickerData [row]
            }
            //hide Importance picker
            importancePicker.isHidden = true
        }
    }
    

    
    
  }
