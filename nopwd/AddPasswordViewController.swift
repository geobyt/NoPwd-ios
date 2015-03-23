//
//  AddPasswordViewController.swift
//  nopwd
//
//  Created by George on 3/22/15.
//  Copyright (c) 2015 George. All rights reserved.
//

import UIKit

class AddPasswordViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var filePath: String?
    var userName: String?
    var pwdDictionary: NSMutableDictionary?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, user userName: String?, path filePath: String?, pwds pwdDictionary: NSDictionary)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.userName = userName
        self.filePath = filePath
        self.pwdDictionary =  pwdDictionary.mutableCopy() as? NSMutableDictionary
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addPassword(sender: AnyObject)
    {
        if countElements(self.userNameTextField.text) > 0 && countElements(self.passwordTextField.text) > 0
        {
            self.pwdDictionary![self.userNameTextField.text] = self.passwordTextField.text
            
            //save
            var error: NSError?
            var jsonData: NSData = NSJSONSerialization.dataWithJSONObject(self.pwdDictionary!, options: NSJSONWritingOptions(), error: &error)!
            var fileName: NSString = "passwords.securedData"

            var encryptedJson: NSData = RNEncryptor.swiftEncryptData(jsonData, password:"A_SECRET_PASSWORD", error:nil)
            encryptedJson.writeToFile(self.filePath!.stringByAppendingPathComponent(fileName), atomically: true)
        }
        
        //nav back
        self.navigationController?.popViewControllerAnimated(true)
    }

}
