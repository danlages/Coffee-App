//
//  LoginVC.swift
//  To-Go
//
//  Created by Sophie Traynor on 30/07/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit
import FirebaseAuth
class CustomerLoginVC: UIViewController, UITextFieldDelegate {

    //MARK: - Properties
    
    @IBOutlet weak var myCoffeeLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    @IBOutlet weak var loginButton: UIButton!
    
    let textColor = UIColor.white
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor(red: 117.0/255.0, green: 117.0/255.0, blue: 117.0/255.0, alpha: 1.0)
        
//        emailAddressLabel.textColor = textColor
  //      passwordLabel.textColor = textColor
        //loginButton.backgroundColor = accentColor //Define Button Asthetics
        loginButton.layer.cornerRadius = 5
        
        
        
        navbar()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Navigation Bar
    
    func navbar()
    {
        navigationController?.navigationBar.prefersLargeTitles = true // Large navigation bar
    }

    //MARK: - Public Functions
    func createAlert(title:String, message:String){
        ///sends pop up to screen displaying message
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    @IBAction func LoginTapped(_ sender: UIButton) {
        ///store values in email and password fields
        if let email = emailTextField.text, let password = passwordTextField.text{
            ///Calls the sign in method using the email and password provided by user
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                ///checks if any errors e.g. user not created yet
                if error == nil{
                    print("Successfully Signed in")
                    ///go to home screen if user has been authenticated
                    self.performSegue(withIdentifier: "loginToSelectCafe", sender: self)
                }
                else{
                    self.createAlert(title: "User does not exist", message: "Check details again or register to create user")
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
