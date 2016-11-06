//
//  ViewController.swift
//  PantryAid
//
//  Created by AdminNick on 11/5/16.
//  Copyright © 2016 AdminNick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var textFieldMoved: Bool = false
    var keyboardIsShowing: Bool = false
    var keyboardHeight: Int!

    @IBOutlet var usernameInput: UITextField!
    @IBOutlet var passwordInput: UITextField!
    
    @IBAction func loginButton(sender: UIButton) {
        self.dismissKeyboard()
        let usernameInputText = self.usernameInput.text!
        let passwordInputText = self.passwordInput.text!
        
        let myUrl = NSURL(string: "http://127.0.0.1/pantry/login.php?username=\(usernameInputText)&password=\(passwordInputText)")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            if error != nil {
                print("Error: \(error)")
            }
            
            let RSnotOptional = responseString as String!
            if RSnotOptional == "Success" {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(usernameInputText, forKey: "username")
                print("SUCCESS")
                self.performSegueWithIdentifier("toShoppingListVC", sender: nil)
            } else if(RSnotOptional == "DNE") {
                self.sendAlert("Login Invalid", message: "Username and password combination not found")
                self.passwordInput.text = ""
                self.usernameInput.text = ""
            } else {
                self.sendAlert("Error", message: "Unable to login")
                self.passwordInput.text = ""
                self.usernameInput.text = ""
            }
            
        }
        task.resume()
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if textFieldMoved == false {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                if keyboardIsShowing == false {
                    self.keyboardHeight = Int(keyboardSize.height)
                    self.view.frame.origin.y -= keyboardSize.height
                    keyboardIsShowing = true
                }
            }
            textFieldMoved = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if textFieldMoved == true {
            if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
                if keyboardIsShowing == true {
                    self.view.frame.origin.y += CGFloat(self.keyboardHeight)
                    keyboardIsShowing = false
                }
            }
            textFieldMoved = false
        }
    }
    
    func dismissKeyboard() {
        self.usernameInput.resignFirstResponder()
        self.passwordInput.resignFirstResponder()
    }
    
    func sendAlert(subject: String, message: String) {
        let alertController = UIAlertController(title: subject, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        swipe.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipe)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

