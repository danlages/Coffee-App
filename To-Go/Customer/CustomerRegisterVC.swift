//
//  RegisterVC.swift
//  To-Go
//
//  Created by Sophie Traynor on 02/08/2018.
//  Copyright © 2018 To-Go. All rights reserved.
//

import UIKit
import FirebaseAuth

class CustomerRegisterVC: UIViewController, UITextFieldDelegate {

    //MARK: - Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navbar()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
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
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
 
    //MARK: - Actions
    @IBAction func RegisterTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text{
            
            if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
                self.createAlert(title: "Error", message: "Required Fields must contain values")
            }
            else{
                //Check if passwords entered match
                if password != confirmPassword {
                    self.createAlert(title: "Error", message: "Passwords must match")
                }
                    //Create user
                else
                {
                    ///Calls the create user method to add a new user to firebase
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        
                        if error == nil{
                            ///Sign user in with created details if user has been created successfully
                            Auth.auth().signIn(withEmail: email, password: password)
                            print("Successfully Registered User")
                            
                            ///go to complete signup screen to get further details about new user
                            self.performSegue(withIdentifier: "registerToSelectCafe", sender: self)
                        }
                        else{
                            self.createAlert(title: "Error", message: "User not created")
                        }
                    }
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
