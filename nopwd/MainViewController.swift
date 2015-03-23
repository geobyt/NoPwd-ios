//
//  MainViewController.swift
//  nopwd
//
//  Created by George on 3/14/15.
//  Copyright (c) 2015 George. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIAlertViewDelegate
{
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func login(sender: AnyObject)
    {
        if countElements(self.userNameTextField.text) > 0 && countElements(self.passwordTextField.text) > 0
        {
            var password: NSString? = SSKeychain.passwordForService("nopwd", account: self.userNameTextField.text)
            
            if password != nil && password!.length > 0
            {
                if self.passwordTextField.text == password
                {
                    self.navigateToPasswordListView()
                }
                else
                {
                    let alertView = UIAlertView(title: "Error Login", message: "Invalid username/password combination.", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
                
            }
            else
            {
                let alertView = UIAlertView(title: "New Account", message: "Do you want to create an account?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
                alertView.show()
            }
            
        }
        else
        {
            let alertView = UIAlertView(title: "Error Input", message: "Username and/or password cannot be empty.", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        switch (buttonIndex)
        {
        case 0:
            break
            
        case 1:
            createAccountInKeychain()
            break
            
        default:
            break
        }
    }
    
    func createAccountInKeychain()
    {
        let result = SSKeychain.setPassword(self.passwordTextField.text, forService: "nopwd", account: self.userNameTextField.text) as Bool
        
        if result
        {
            self.navigateToPasswordListView()
        }
    }
    
    func navigateToPasswordListView()
    {
        let passwordListView = PasswordListViewController(nibName: "PasswordListViewController", bundle: nil, user: self.userNameTextField.text)
        self.navigationController?.pushViewController(passwordListView, animated: true)
    }
}
