//
//  ViewController.swift
//  Project
//
//  Created by  on 2023-03-14.
//

import UIKit

class ViewController: UIViewController {
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBAction func signInCheck(_ sender: Any) {
        //verify the signing in info
        let auth = mainDelegate.verifyLogintInfo(inputEmail: tfEmail.text!, inputPassword: tfPassword.text!)
        if auth {
            performSegue(withIdentifier: "signInToHome", sender: nil)
        } else {
            let alertControl = UIAlertController(title:"Sign In",message:"Email or password does not match",preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertControl.addAction(alertAction)
            present(alertControl,animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

}

