//
//  CreateAccountViewController.swift
//  Project
//
//  Created by ChuantaiHu on 2023-03-31.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //birthday var with default empty
    var birthday:String = ""
    //level var with default 1
    var level:Int = 1

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var pkBirdthday: UIDatePicker!
    @IBOutlet weak var segLevel: UISegmentedControl!
    @IBOutlet weak var slAge: UISlider!
    
    
    @IBAction func levelChanged(sender: UISegmentedControl) {
        updateLevel(sender)
    }
    
    @IBAction func pkBirthdayChanged(_ sender: Any) {
        updateBirthday()
    }
    
    @IBAction func slAgeChanged(_ sender: Any) {
        updateTextFieldAge()
    }
    @IBAction func registerNewAccount(_ sender: UIButton) {
        //save into database table users
        saveNewUserIntoDatabase()
    }
    @IBAction func cancelRegister(_ sender: UIButton) {
        //clear all textfield
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //when the datepicker is clicked, change the date time to store
    func updateBirthday(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthday = dateFormatter.string(from: pkBirdthday.date)
    
    }
    
    //save the age slider value, convert and format then display in textfield
    func updateTextFieldAge(){
        let age = slAge.value
        let strAge = String(format:"%.0f",age)
        tfAge.text = strAge
        
    }

    //update the level as to the segmented control changes
    func updateLevel(_ segmentedController:UISegmentedControl){
        //switch to selectedSgementIndex
        switch segmentedController.selectedSegmentIndex{
        case 0:
            level = 1
        case 1:
            level = 2
        case 2:
            level = 3

        default:
            break
        }
    }
    
    //save new user in the database
    @IBAction func saveNewUserIntoDatabase(){
        //init a User
        let user:User = User.init()
        user.initWithData(userName: tfName.text!, theEmail: tfEmail.text!, password: tfPassword.text!, birthday: birthday, level: level)
        
        //TODO: make sure the eamil and password is not empty and satisfy the requirement
        
        
        
        //save into database
        let returnCode:Bool = mainDelegate.insertIntoDatabase(user: user)
        
        var returnMSG:String = "User Added"
        
        if returnCode == false {
            returnMSG = "User Add Failed"
        }
        
        let alertController = UIAlertController(title: "SQLite Add", message: returnMSG, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true)
    }
    
    //cancel
    @IBAction func cancelRegister(){
        tfName.text = ""
        tfAge.text = ""
        tfEmail.text = ""
        pkBirdthday.date = Date.now
        segLevel.selectedSegmentIndex = 0
        
    }
}
